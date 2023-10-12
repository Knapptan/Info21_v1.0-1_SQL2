-- 1) Написать функцию, возвращающую таблицу TransferredPoints в более человекочитаемом виде
-- Ник пира 1, ник пира 2, количество переданных пир поинтов. 
-- Количество отрицательное, если пир 2 получил от пира 1 больше поинтов.

CREATE OR REPLACE FUNCTION point1()
RETURNS TABLE(peer1 varchar, peer2 varchar, "PointsAmount" integer) AS $$
BEGIN
	RETURN QUERY
	SELECT a.checkingpeer, a.checkedpeer, (a.pointsamount - b.pointsamount)
	FROM TransferredPoints AS a
	JOIN TransferredPoints AS b
	ON b.checkingpeer = a.checkedpeer AND b.checkedpeer = a.checkingpeer AND a.id < b.id;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM point1();




-- 2) Написать функцию, которая возвращает таблицу вида: ник пользователя, название проверенного задания, кол-во полученного XP
-- В таблицу включать только задания, успешно прошедшие проверку (определять по таблице Checks). 
-- Одна задача может быть успешно выполнена несколько раз. В таком случае в таблицу включать все успешные проверки.

CREATE  OR REPLACE FUNCTION point2()
RETURNS TABLE (peer varchar, task varchar, XP integer) AS $$
BEGIN
	RETURN QUERY
	 SELECT c.peer AS peer, c.task AS task, xp.XPamount AS XP FROM checks AS c
	JOIN xp
	ON xp."Check" = c.id
	JOIN p2p
	ON p2p."Check" = c.id
	WHERE p2p.state = 'Success';
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM point2();

-- 3) Написать функцию, определяющую пиров, которые не выходили из кампуса в течение всего дня
-- Параметры функции: день, например 12.05.2022. 
-- Функция возвращает только список пиров.

CREATE OR REPLACE FUNCTION point3(d date)
RETURNS TABLE(peer varchar) AS $$
BEGIN
	RETURN QUERY
	SELECT TimeTracking.peer AS p FROM TimeTracking
	WHERE date = d AND state = 1
	
	EXCEPT

	SELECT TimeTracking.peer AS p FROM TimeTracking
	WHERE date = d AND state = 2;
END;
$$ LANGUAGE plpgsql;

-- Тесты
-- Вставляем данные что человек не выходил из кампуса
-- INSERT INTO timetracking
-- VALUES((select max(id) from timetracking)+1, 'oceanusp', '2023-09-09', '11:11:11', 1);
-- Проверяем работы процедуры
-- SELECT * FROM point3('2023-09-09');
-- Успешно
-- Возвращаем базу в исходное состояние
-- DELETE FROM timetracking
-- WHERE id = (select max(id) from timetracking);





-- 4) Посчитать изменение в количестве пир поинтов каждого пира по таблице TransferredPoints
-- Результат вывести отсортированным по изменению числа поинтов. 
-- Формат вывода: ник пира, изменение в количество пир поинтов

DROP PROCEDURE IF EXISTS point4(result refcursor);
CREATE OR REPLACE PROCEDURE point4(IN result refcursor) AS $$
BEGIN
	OPEN result FOR
	SELECT amount_checking.checkingpeer AS "Peer", amount_checking.amount - amount_checked.amount AS "PointsChange" FROM 
	(SELECT checkingpeer, SUM(pointsamount) AS amount FROM TransferredPoints
	GROUP BY checkingpeer) AS amount_checking --подсичитали сколько монет заработали
	JOIN
	(SELECT checkedpeer, SUM(pointsamount) AS amount FROM TransferredPoints
	GROUP BY checkedpeer) AS amount_checked --подсчитали сколько монет потратили
	ON amount_checking.checkingpeer = amount_checked.checkedpeer
	ORDER BY "PointsChange";
END;
$$ LANGUAGE plpgsql;


-- CALL point4('result');
-- FETCH ALL IN "result";




-- 5) Посчитать изменение в количестве пир поинтов каждого пира по таблице, возвращаемой первой функцией из Part 3

-- Результат вывести отсортированным по изменению числа поинтов. 
-- Формат вывода: ник пира, изменение в количество пир поинтов


CREATE OR REPLACE PROCEDURE point5(IN result refcursor) AS $$
	BEGIN
		OPEN result FOR
		WITH checking AS (SELECT peer1, SUM("PointsAmount") FROM point1()
									   GROUP BY peer1),
					 checked AS (SELECT peer2, SUM("PointsAmount") FROM point1()
									   GROUP BY peer2)
					 SELECT COALESCE(checked.peer2, checking.peer1) AS peer, (COALESCE(checking.sum, 0) - COALESCE(checked.sum, 0)) AS "PointsChange" 
					 FROM checking FULL JOIN checked
					 ON checking.peer1 = checked.peer2;
	END;
	$$ LANGUAGE plpgsql;
	

-- CALL point5('result');
-- FETCH ALL IN "result";


-- 6) Определить самое часто проверяемое задание за каждый день
-- При одинаковом количестве проверок каких-то заданий в определенный день, вывести их все. 
-- Формат вывода: день, название задания

DROP PROCEDURE IF EXISTS point6(result refcursor);
CREATE OR REPLACE PROCEDURE point6(IN result refcursor) AS $$
BEGIN
	OPEN result FOR
	WITH count_task_checks AS (SELECT task, date, COUNT(task) AS count_task FROM checks
							  GROUP BY date, task),
		max_count_task AS (SELECT task, date, count_task AS max FROM count_task_checks AS c
						  WHERE count_task = (SELECT MAX(count_task) FROM count_task_checks 
											 WHERE c.date = count_task_checks.date))
	SELECT date AS "Day", task AS "Task" FROM max_count_task ORDER BY date;
END;
$$ LANGUAGE plpgsql;


-- CALL point6('result');
-- FETCH ALL IN "result";





-- 7) Найти всех пиров, выполнивших весь заданный блок задач и дату завершения последнего задания
-- Параметры процедуры: название блока, например "CPP". 
-- Результат вывести отсортированным по дате завершения. 
-- Формат вывода: ник пира, дата завершения блока (т.е. последнего выполненного задания из этого блока)

CREATE OR REPLACE PROCEDURE point7(IN res refcursor, IN block text) AS $$
BEGIN
	OPEN res FOR
	WITH find_tasks AS (SELECT substring(tasks.title FROM '\D+\d+') AS task FROM tasks),
		tasks_for_blocks AS (SELECT t.task AS task FROM find_tasks AS t
						WHERE (substring(t.task FROM '\D+') = 'C')),
		tasks_passed AS (SELECT c.peer, c.task AS title, c.date FROM checks AS c
							JOIN tasks_for_blocks AS t ON substring(c.task FROM '\D+\d+') = t.task
							WHERE c.id IN (SELECT xp."Check" FROM xp)),
		result AS (SELECT p.peer, p.date AS "Day" FROM tasks_passed AS p
					 GROUP BY p.peer, p.date
					 HAVING substring(MAX(p.title), '\D+\d+') = (SELECT MAX(task) FROM tasks_for_blocks))
	SELECT * FROM result;
END;
$$ LANGUAGE plpgsql;


-- CALL point7('res', 'C');
-- FETCH ALL IN "res";





-- 8) Определить, к какому пиру стоит идти на проверку каждому обучающемуся
-- Определять нужно исходя из рекомендаций друзей пира, т.е. нужно найти пира, проверяться у которого рекомендует наибольшее число друзей. 
-- Формат вывода: ник пира, ник найденного проверяющего

WITH friends_for_each_peer AS (SELECT nickname,
						  (CASE WHEN peers.nickname = friends.peer1 THEN peer2
						  ELSE peer1 END ) AS friend FROM friends
						  JOIN peers ON peers.nickname = friends.peer1 OR peers.nickname = friends.peer2),
	recommended_peers AS (SELECT nickname, r.recommendedpeer FROM friends_for_each_peer AS f
						 JOIN recommendations AS r ON r.peer = f.friend),
	count_rec AS (SELECT nickname, recommendedpeer, COUNT(recommendedpeer) FROM recommended_peers
				 GROUP BY nickname, recommendedpeer),
	max_recommended_peer AS (SELECT nickname, MAX(count) FROM count_rec
							GROUP BY nickname)
SELECT count_rec.nickname, count_rec.recommendedpeer FROM count_rec
JOIN max_recommended_peer
ON count_rec.nickname = max_recommended_peer.nickname AND count_rec.count = max_recommended_peer.max;


-- 9) Определить процент пиров, которые:
-- Приступили только к блоку 1
-- Приступили только к блоку 2
-- Приступили к обоим
-- Не приступили ни к одному

-- Пир считается приступившим к блоку, если он проходил хоть одну проверку любого задания из этого блока (по таблице Checks)
-- Параметры процедуры: название блока 1, например SQL, название блока 2, например A. 
-- Формат вывода: процент приступивших только к первому блоку, процент приступивших только ко второму блоку, процент приступивших к обоим, процент не приступивших ни к одному


CREATE OR REPLACE FUNCTION peer_blocks_started(block1_name varchar,block2_name varchar)
RETURNS TABLE (
    StartedBlock1 numeric,
    StartedBlock2 numeric,
    StartedBothBlocks numeric,
    DidntStartAnyBlock numeric
	
)
AS $BODY$
DECLARE
    total_peers bigint;
	amount_peers numeric; 
    started_block1 bigint;
    started_block2 bigint;
    started_both_blocks bigint;
    didnt_start_any_block bigint;
BEGIN
DROP TABLE IF EXISTS block_statistics;
CREATE TABLE block_statistics (
    StartedBlock1 numeric,
    StartedBlock2 numeric,
    StartedBothBlocks numeric,
    DidntStartAnyBlock numeric
);
  SELECT COUNT(DISTINCT Peer) INTO total_peers FROM Checks; 
  
  SELECT COUNT(*) INTO amount_peers FROM peers; 
  
  SELECT COUNT(DISTINCT Peer) INTO started_block1
    FROM Checks
    WHERE Task LIKE '%'||block1_name||'%';

  SELECT COUNT(DISTINCT Peer) INTO started_block2
    FROM Checks
    WHERE Task LIKE '%'||block2_name||'%';
  
  SELECT COUNT(DISTINCT Peer) INTO started_both_blocks
    FROM Checks
    WHERE Task LIKE '%'||block1_name||'%' AND Peer IN (
    SELECT DISTINCT Peer FROM Checks WHERE Task LIKE '%'||block2_name||'%'
    );

  didnt_start_any_block := total_peers - started_block1 - started_both_blocks+ started_both_blocks;
  
  INSERT INTO block_statistics(StartedBlock1, StartedBlock2, StartedBothBlocks, DidntStartAnyBlock)
    VALUES
    (ROUND(started_block1 * (amount_peers / 100),1), 
	 ROUND(started_block2 * (amount_peers / 100),1),
	 ROUND(started_both_blocks * (amount_peers / 100),1),
	 ROUND(didnt_start_any_block * (amount_peers / 100),1));
  RETURN QUERY
  SELECT * FROM block_statistics;
  DROP TABLE IF EXISTS block_statistics;
END;
$BODY$
LANGUAGE plpgsql;


--Тестируем
--SELECT *  from peer_blocks_started('C5_s21_decimal', 'C3_s21_string+');




-- 10) Определить процент пиров, которые когда-либо успешно проходили проверку в свой день рождения
-- Также определите процент пиров, которые хоть раз проваливали проверку в свой день рождения. 
-- Формат вывода: процент пиров, успешно прошедших проверку в день рождения, процент пиров, проваливших проверку в день рождения


DROP FUNCTION IF EXISTS birthday_peer_check();
CREATE OR REPLACE FUNCTION birthday_peer_check()
RETURNS TABLE (
    SuccessfulChecks numeric,
    UnsuccessfulChecks numeric
)
AS $BODY$
DECLARE
	total_peers bigint;
	successful_peers bigint;
	unsuccessful_peers bigint;
BEGIN

	DROP TABLE IF EXISTS birthday_peer_statistics;

	CREATE TABLE birthday_peer_statistics (
    SuccessfulChecks numeric,
    UnsuccessfulChecks numeric
);

	SELECT COUNT(DISTINCT nickname) INTO total_peers FROM peers;
	
	SELECT COUNT(DISTINCT p2p.CHeckingPeer) INTO successful_peers
	FROM p2p
	JOIN checks ch ON ch.id = p2p."Check"
	JOIN peers p ON p.nickname = ch.peer
	WHERE p2p.state = 'Success' AND to_char(ch.date, 'mon DD') =  to_char(p.birthday, 'mon DD');
	
	SELECT COUNT(DISTINCT p2p.CheckingPeer) INTO unsuccessful_peers
	FROM p2p
	JOIN checks ch ON ch.id = p2p."Check"
	JOIN peers p ON p.nickname = ch.peer
	WHERE p2p.state = 'Failure' AND to_char(ch.date, 'mon DD') =  to_char(p.birthday, 'mon DD');

	INSERT INTO birthday_peer_statistics(SuccessfulChecks, UnsuccessfulChecks)
	VALUES
	(ROUND((successful_peers * 100.0) / total_peers, 1),ROUND((unsuccessful_peers * 100.0) / total_peers, 1));
	RETURN QUERY
	SELECT * FROM birthday_peer_statistics;
	DROP TABLE IF EXISTS birthday_peer_statistics;
END;
$BODY$
LANGUAGE plpgsql;

-- ТЕСТЫ
-- Обновляем даты рождения на дату проверки чтобы выполнилась процедура
-- UPDATE peers SET birthday = '1990-03-02' WHERE nickname = 'maganand';
-- UPDATE peers SET birthday = '1990-03-10' WHERE nickname = 'knapptan';
-- вызываем процедуру
-- SELECT * from birthday_peer_check();

-- Сверяем данные с таблицей п2п
-- SELECT * from checks JOIN p2p ON p2p."Check" = checks.id
-- WHERE (peer = 'maganand' AND "date" = '2023-03-02') OR ( peer = 'knapptan' AND "date" = '2023-03-10');

-- Успешно
-- Возвращаем данные к исходникам
-- UPDATE peers SET birthday = '1975-10-31' WHERE nickname = 'maganand';
-- UPDATE peers SET birthday = '1998-07-20' WHERE nickname = 'knapptan';




-- 11) Определить всех пиров, которые сдали заданные задания 1 и 2, но не сдали задание 3
-- Параметры процедуры: названия заданий 1, 2 и 3. 
-- Формат вывода: список пиров

CREATE OR REPLACE FUNCTION peers_secific_tasks_complete(
	block1 varchar,
    block2 varchar,
    block3 varchar)
RETURNS TABLE (
    Peers varchar
)
AS $BODY$
BEGIN
RETURN QUERY
WITH block1_success AS (
SELECT DISTINCT ch.peer 
FROM checks ch
JOIN p2p ON ch.id = p2p."Check"
JOIN Verter v ON ch.id = v."Check"
WHERE 
ch.task = block1 AND p2p.state = 'Success' AND v.state = 'Success'),

block2_success AS (
SELECT DISTINCT ch.peer 
FROM checks ch
JOIN p2p ON ch.id = p2p."Check"
JOIN Verter v ON ch.id = v."Check"
WHERE 
ch.task = block2 AND p2p.state = 'Success' AND v.state = 'Success'),

block3_success AS (
SELECT DISTINCT ch.peer 
FROM checks ch
JOIN p2p ON ch.id = p2p."Check"
JOIN Verter v ON ch.id = v."Check"
WHERE 
ch.task = block3 AND p2p.state = 'Success' AND v.state = 'Success')

SELECT DISTINCT block1_success.Peer
FROM block1_success
JOIN block2_success ON block1_success.Peer = block2_success.Peer
WHERE block1_success.Peer NOT IN (SELECT Peer FROM block3_success);

END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM peers_secific_tasks_complete('C2_SimpleBashUtils','C2_SimpleBashUtils','A4_Crypto');



-- 12) Используя рекурсивное обобщенное табличное выражение, для каждой задачи вывести кол-во предшествующих ей задач
-- То есть сколько задач нужно выполнить, исходя из условий входа, чтобы получить доступ к текущей. 
-- Формат вывода: название задачи, количество предшествующих

CREATE OR REPLACE FUNCTION recursive_task_count()
RETURNS TABLE (
    Task varchar,
	PrevCount bigint) 
AS $BODY$
BEGIN 
RETURN QUERY
WITH RECURSIVE rec AS (
	SELECT title AS task1, 0 AS cnt 
	FROM tasks 
	UNION ALL
	SELECT t.title, rec.cnt + 1
	FROM rec
	JOIN tasks t ON rec.task1 = t.parenttask)
SELECT task1 AS "Task", MAX(cnt)::bigint AS "PrevCount"
FROM rec
GROUP BY task1
ORDER BY 2 DESC;

END;
$BODY$ 
LANGUAGE plpgsql;

SELECT *  from recursive_task_count();




-- 13) Найти "удачные" для проверок дни. 
-- День считается "удачным", если в нем есть хотя бы N идущих подряд успешных проверки

DROP FUNCTION IF EXISTS find_lucky_days(integer);

CREATE OR REPLACE FUNCTION find_lucky_days(IN N int)
RETURNS TABLE (Lucky_days date)
AS $BODY$
BEGIN
RETURN QUERY
WITH  all_checks AS (
                SELECT ch.id, ch.date, p2p.time, p2p.state, xp.xpamount FROM checks ch, p2p, xp
                WHERE ch.id = p2p."Check" AND (p2p.state = 'Success' OR p2p.state = 'Failure')
                AND ch.id = xp."Check" AND xpamount >= (SELECT tasks.maxxp FROM tasks WHERE tasks.title = ch.task) * 0.8
                ORDER BY ch.date, p2p.time),
  amount_of_succesful_checks_in_a_row AS (
        SELECT id, date, time, state,
        (CASE WHEN state = 'Success' THEN row_number() over (partition by state, date) ELSE 0 END) AS amount
        FROM all_checks ORDER BY date),
  max_in_day AS (SELECT a.date, MAX(amount) amount FROM amount_of_succesful_checks_in_a_row a GROUP BY date)
SELECT date FROM max_in_day WHERE amount >= N;
END;
$BODY$ 
LANGUAGE plpgsql;

-- SELECT * FROM find_lucky_days(2);




-- 14) Определить пира с наибольшим количеством XP
-- Формат вывода: ник пира, количество XP

CREATE OR REPLACE FUNCTION find_peer_with_max_xp()
RETURNS TABLE (Peer varchar, XP bigint)
AS $BODY$
BEGIN
RETURN QUERY
    WITH succesful_projects AS
    (SELECT ch.peer, ch.id , ch.task 
	FROM checks ch
	JOIN xp ON ch.id = xp."Check"),
	
	 xp_amount AS (SELECT s.peer, xp.xpamount, s.task, s.id FROM succesful_projects s, xp WHERE s.id = xp."Check"),
     
	 sum_xp AS (SELECT x.peer, SUM(x.xpamount) AS xp FROM xp_amount x GROUP BY x.peer ORDER BY xp DESC)
    
	SELECT * FROM sum_xp WHERE sum_xp.xp = (SELECT MAX(sum_xp.xp) FROM sum_xp);
END;
$BODY$ 
LANGUAGE plpgsql;

-- SELECT * FROM find_peer_with_max_xp();

-- 15) Определить пиров, приходивших раньше заданного времени не менее N раз за всё время
-- Параметры процедуры: время, количество раз N. 
-- Формат вывода: список пиров

CREATE OR REPLACE FUNCTION find_peer_earlier_specified(entry_time TIME, amount INTEGER)
RETURNS TABLE (Peer varchar)
AS $BODY$
BEGIN
RETURN QUERY
WITH tmp_table AS (
  SELECT timetracking.peer, COUNT(timetracking.peer) AS count_state
  FROM timetracking
  WHERE timetracking.time < entry_time
  AND timetracking.state = 1
  GROUP BY timetracking.peer
)
SELECT tmp.peer 
FROM tmp_table tmp
WHERE tmp.count_state >= amount
ORDER BY tmp.peer;
END
$BODY$ 
LANGUAGE plpgsql;

-- SELECT * FROM find_peer_earlier_specified('12:00:00', 1)



-- 16) Определить пиров, выходивших за последние N дней из кампуса больше M раз
-- Параметры процедуры: количество дней N, количество раз M. 
-- Формат вывода: список пиров

DROP FUNCTION IF EXISTS find_peer_exit_more(N int, M int);
CREATE OR REPLACE FUNCTION find_peer_exit_more(N int, M int)
RETURNS TABLE (Peer varchar)
AS $BODY$
    DECLARE 
 date_start date := now()::date - N;
BEGIN
RETURN QUERY
        WITH exits AS (
            SELECT tt.peer, COUNT(tt.date) exits FROM timetracking tt
            WHERE state = '2' AND tt.date BETWEEN date_start AND now()::date
            GROUP BY tt.peer
        )
        SELECT e.peer  FROM exits e WHERE e.exits >= M;
    end;
$BODY$
LANGUAGE plpgsql;

-- SELECT * FROM find_peer_exit_more(200, 3);



-- 17) Определить для каждого месяца процент ранних входов
-- Для каждого месяца посчитать, сколько раз люди, родившиеся в этот месяц, приходили в кампус за всё время (будем называть это общим числом входов). 
-- Для каждого месяца посчитать, сколько раз люди, родившиеся в этот месяц, приходили в кампус раньше 12:00 за всё время (будем называть это числом ранних входов). 
-- Для каждого месяца посчитать процент ранних входов в кампус относительно общего числа входов. 
-- Формат вывода: месяц, процент ранних входов

DROP FUNCTION IF EXISTS count_early_entries_month();
CREATE OR REPLACE FUNCTION count_early_entries_month()
RETURNS table (Month varchar, EarlyEntries numeric)
AS $BODY$
BEGIN
RETURN QUERY
WITH
    table_part1 AS (
        SELECT date_part('month', t.date) AS number_month,
               to_char(t.date, 'Month') AS month_name,
               count(peer) AS total_entry
        FROM timetracking t
        JOIN peers p ON p.nickname = t.peer
        WHERE state = 1 AND date_part('month', t.date) = date_part('month', p.birthday)
        GROUP BY 1, 2
    ),
    table_part2 AS (
        SELECT date_part('month', t.date) AS number_month,
               to_char(t.date, 'Month') AS month_name,
               count(peer) AS early_entry
        FROM timetracking t
        JOIN peers p ON p.nickname = t.peer
        WHERE state = 1 AND date_part('month', t.date) = date_part('month', p.birthday)
        AND t.time < '12:00:00'
        GROUP BY 1, 2
    )
SELECT table_part1.month_name::character varying AS "Month", 
       ROUND(table_part2.early_entry / table_part1.total_entry::numeric, 2) * 100 AS "EarlyEntries"
FROM table_part1
JOIN table_part2 ON table_part1.number_month = table_part2.number_month;
END;
$BODY$
LANGUAGE plpgsql;

-- SELECT * FROM count_early_entries_month();

