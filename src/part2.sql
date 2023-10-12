--1) Написать процедуру добавления P2P проверки
-- Параметры: ник проверяемого, ник проверяющего, название задания, статус P2P проверки, время. 
-- Если задан статус "начало", добавить запись в таблицу Checks (в качестве даты использовать сегодняшнюю). 
-- Добавить запись в таблицу P2P. 
-- Если задан статус "начало", в качестве проверки указать только что добавленную запись, иначе указать проверку с незавершенным P2P этапом.

CREATE OR REPLACE PROCEDURE add_peer_review ( IN checked_peer varchar, 
											 IN checking_peer varchar, 
											 IN task_name text, 
											 IN review_status check_status,
										  	 IN review_time time) AS 
$BODY$
BEGIN
	IF(review_status = 'Start') 
		THEN
		IF((SELECT COUNT(*) FROM p2p  
		   JOIN checks ch ON p2p."Check" = ch.id 
				WHERE p2p.checkingpeer = checking_peer AND ch.peer = checked_peer AND ch.task = task_name) = 1)
		   	THEN 
				RAISE EXCEPTION 'Ошибка: Такая проверка уже есть';
			ELSIF (( SELECT COUNT(*) FROM checks WHERE peer = checked_peer AND task = task_name) = 1)
				THEN
					-- RAISE NOTICE 'Не добавляем в чекс';
					INSERT INTO p2p
					VALUES((SELECT MAX(id) FROM p2p) + 1,(SELECT id FROM checks 
														  WHERE peer = checked_peer AND task = task_name ),
						   								   checking_peer, review_status, review_time);	
			ELSE
				INSERT INTO Checks
				VALUES((SELECT MAX(id) FROM checks) + 1, checked_peer, task_name, NOW() );

				INSERT INTO p2p
				VALUES((SELECT MAX(id) FROM p2p) + 1,(SELECT MAX(id) FROM checks),checking_peer, review_status, review_time);
		END IF;
	ELSE
		INSERT INTO p2p
		VALUES((SELECT MAX(id) FROM p2p) + 1,(SELECT "Check" FROM p2p 
											   JOIN checks ch ON ch.id = p2p."Check"
											   WHERE p2p.checkingpeer = checking_peer 
											   AND ch.peer = checked_peer
											   AND ch.task = task_name), checking_peer, review_status, review_time);
	END IF;
END;
$BODY$
LANGUAGE plpgsql;
		
-- ТЕСТЫ --
-- Добавляем записи в таблицы checks, p2p
-- Корректный ввод для записи:

-- CALL add_peer_review('knapptan', 'oceanusp', 'C5_s21_decimal', 'Start'::check_status, '11:11:11');
-- SELECT * FROM checks;
-- SELECT * FROM p2p;
-- Успешно -- (check id = 31)

-- Вызываем Ошибку: Такая проверка уже есть
-- CALL add_peer_review ('knapptan', 'oceanusp', 'C5_s21_decimal', 'Start'::check_status, '11:11:11');
-- Успешно

-- Добавление записей для случая, когда у проверяющего имеется незакрытая проверка, то есть не добавляем в checks
-- Добавляем записи в таблицу p2p
-- INSERT INTO checks
-- VALUES(32,'emerosro','DO5_SimpleDocker','2023-10-23');
-- CALL add_peer_review('emerosro', 'oceanusp', 'DO5_SimpleDocker', 'Start'::check_status, '12:12:12');

-- SELECT * FROM p2p;
-- DELETE FROM p2p
-- WHERE "Check" = 32

-- SELECT * FROM checks;
-- DELETE FROM checks
-- WHERE id = 32

-- SELECT * FROM p2p;
-- Успешно


-- ///////////////////// --


-- 2) Написать процедуру добавления проверки Verter'ом
-- Параметры: ник проверяемого, название задания, статус проверки Verter'ом, время. 
-- Добавить запись в таблицу Verter (в качестве проверки указать 
-- проверку соответствующего задания с самым поздним (по времени) успешным P2P этапом)


CREATE OR REPLACE PROCEDURE add_verter_review (IN checked_peer varchar,
											   IN task_name text,
											   IN status_review_verter check_status,
											   IN verter_time time)AS
$BODY$
BEGIN
	IF(status_review_verter = 'Start')
		THEN
		IF((SELECT MAX(p2p.time) FROM p2p
			JOIN checks ch ON ch.id = p2p."Check"
		   WHERE ch.peer = checked_peer AND ch.task = task_name AND p2p.state = 'Success') IS NOT NULL)
		   THEN
		   INSERT INTO verter
			VALUES((SELECT MAX(id) FROM verter)+ 1, (SELECT DISTINCT ch.id FROM p2p
				  									JOIN checks ch ON ch.id = p2p."Check"
				  									WHERE ch.peer = checked_peer AND ch.task = task_name AND p2p.state = 'Success'),
				  status_review_verter, verter_time);
		ELSE
			RAISE EXCEPTION 'Не заврешена проверка у другого пира или она неуспешна';
			END IF;
	ELSE
		INSERT INTO verter
		VALUES((SELECT MAX(id) FROM verter)+ 1, (SELECT "Check" FROM verter
												GROUP BY "Check"
												HAVING COUNT(*) % 2 = 1),
			  status_verter_review, verter_time);
	END IF;
END;
$BODY$
LANGUAGE plpgsql;


-- Добавляем записи в таблицу verter
-- Корректный ввод
-- Сначала добавим успешную проверку в п2п
-- CALL add_peer_review('knapptan', 'emerosro', 'C5_s21_decimal', 'Success'::check_status, '14:14:14');
-- CALL add_peer_review('knapptan', 'emerosro', 'C5_s21_decimal', 'Success'::check_status, '14:55:55');
-- Затем отправляем кнаптана к вертеру
-- CALL add_verter_review('knapptan', 'C5_s21_decimal', 'Start', '14:55:56');
-- SELECT * from verter
-- Успешно
-- Удаляем все проверки этого теста
-- DELETE FROM verter WHERE id = (SELECT MAX(id) FROM verter);
-- DELETE FROM p2p WHERE id = (SELECT MAX(id) FROM p2p);
-- DELETE FROM p2p WHERE id = (SELECT MAX(id) FROM p2p);
-- SELECT * from verter
-- SELECT * FROM p2p

-- Ожидаем ошибку 'Не заврешена проверка у другого пира или она неуспешна'
-- Попытка добавления записи при условии, что p2p проверка еще не завершена
-- CALL add_verter_review('knapptan', 'C5_s21_decimal', 'Start', '14:14:14');
-- Успешно


-- ///////////////////// --


-- 3) Написать триггер: после добавления записи со статутом "начало" в таблицу P2P,
-- изменить соответствующую запись в таблице TransferredPoints
                     
CREATE OR REPLACE FUNCTION fnc_trg_update_transferpoints()
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF(NEW.state = 'Start')
	THEN
		UPDATE transferredpoints
        SET pointsamount = pointsamount + 1
        WHERE checkingpeer = NEW.checkingpeer
        AND checkedpeer = (
            SELECT ch.peer
            FROM p2p
			JOIN checks ch ON p2p."Check" = ch.id
            WHERE "Check" = NEW."Check"
            AND p2p.state = 'Start'
        );
	IF NOT FOUND 
	THEN
		INSERT INTO transferredpoints(CheckingPeer, CheckedPeer, PointsAmount)
            VALUES ( NEW.checkingpeer, (
                SELECT ch.peer
                FROM p2p
                JOIN checks ch ON p2p."Check" = ch.id
                WHERE "Check" = NEW."Check" AND state = 'Start'), 1);
        END IF;							
	END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS trg_update_transferpoints ON p2p
CREATE TRIGGER trg_update_transferpoints
AFTER INSERT ON p2p
FOR EACH ROW EXECUTE FUNCTION fnc_trg_update_transferpoints();


-- ТЕСТЫ --
-- Проверяем работу тригера путем вставки данных в таблицу п2п.
-- Для начала создадим новую проверку в таблицу п2п
-- CALL add_peer_review('oceanusp', 'emerosro', 'DO2_Linux Network', 'Start'::check_status, '16:16:16');
-- select * from transferredpoints
-- WHERE checkingpeer = 'emerosro'
-- прп коин добавился для emerosro
-- Затем добавим еще одну проверку п2п 
-- CALL add_peer_review('oceanusp', 'emerosro', 'C8_3DViewer_v1.0', 'Start'::check_status, '17:17:17');
-- select * from transferredpoints
-- WHERE checkingpeer = 'emerosro'
-- Еще один прп коин для emerosro добавился и pointsamount увеличился
-- Успешно
-- Удаляем все данные которые использоваи для тестов
-- DELETE FROM p2p
-- WHERE "Check" = 31 OR "Check" = 32;
-- DELETE FROM checks
-- WHERE id = 31 OR id = 32;



-- ///////////////////// --


-- 4) Написать триггер: перед добавлением записи в таблицу XP, проверить корректность добавляемой записи
-- Запись считается корректной, если:

-- Количество XP не превышает максимальное доступное для проверяемой задачи
-- Поле Check ссылается на успешную проверку.Если запись не прошла проверку, не добавлять её в таблицу.

CREATE OR REPLACE FUNCTION fnc_trg_check_add_in_xpTabels()
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF((SELECT maxxp FROM checks
	   JOIN tasks ON tasks.title = checks.task
	   WHERE NEW."Check" = checks.id) >= NEW.xpamount) AND
	   ((SELECT COUNT(*) FROM checks
		JOIN p2p ON p2p."Check" = checks.id
		WHERE p2p.state = 'Success' AND checks.id = NEW."Check") = 1) AND 
		((SELECT COUNT(*) FROM checks
		JOIN verter ON verter."Check" = checks.id
		WHERE verter.state = 'Success' AND checks.id = NEW."Check") = 1)
	THEN
	RETURN (NEW.id, NEW."Check", NEW.xpamount);
	ELSE
	RAISE EXCEPTION 'Количество ХР превышает максимально возможное за этот проект или какая-то из проверок провалена';
	END IF;
END;
$BODY$ 
LANGUAGE plpgsql;

CREATE TRIGGER trg_check_add_in_xpTabels
BEFORE INSERT ON XP
    FOR EACH ROW EXECUTE FUNCTION fnc_trg_check_add_in_xpTabels();


select * from xp
-- ТЕСТЫ --
-- Добавление записи в таблицу ХР при условии, что все проверки успешны (меняем кол-во экспы)
-- INSERT INTO xp (id, "Check", xpamount)
-- VALUES (23, 2, 250);
-- Успешно
-- DELETE FROM xp WHERE id = 23;

-- Добавление записи в таблицу ХР при условии, что проверка р2р -  Success, а verter Failure
-- Ожидаем ошибку 'Количество ХР превышает максимально возможное за этот проект или какая-то из проверок провалена'
-- INSERT INTO xp (id, "Check", xpamount)
-- VALUES (23, 4, 250);
-- -- Успешно

-- Добавление записи в таблицу ХР при условии, что проверка р2р - Failure
-- Ожидаем ошибку 'Количество ХР превышает максимально возможное за этот проект или какая-то из проверок провалена'
-- INSERT INTO xp (id, "Check", xpamount)
-- VALUES (23, 1, 250);
-- Успешно

-- Добавление записи в таблицу ХР при условии, что количество xp превышает максимальное количество
-- Ожидаем ошибку 'Количество ХР превышает максимально возможное за этот проект или какая-то из проверок провалена'
-- INSERT INTO xp (id, "Check", xpamount)
-- VALUES (23, 2, 251);
-- Успешно

