-- 1) Создать хранимую процедуру, которая, не уничтожая базу данных, уничтожает все те таблицы текущей базы данных, имена которых начинаются с фразы 'TableName'.
DROP PROCEDURE IF EXISTS delete_table ();
CREATE OR REPLACE PROCEDURE delete_table ()
AS
$BODY$
DECLARE
    table_name_to_delete name;
    table_name_cursor RECORD;
    sql_request text;
BEGIN
    table_name_to_delete := 'tablename';
    
    FOR table_name_cursor IN (SELECT table_name
                              FROM information_schema.tables
                              WHERE table_name LIKE concat(table_name_to_delete, '%') 
                              AND table_schema = 'public')
    LOOP
        sql_request := 'DROP TABLE ' || table_name_cursor.table_name;
        EXECUTE sql_request;
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;

-- Проверяем есть ли таблицы в текущей базе данных, имена которых начинаются с фразы 'TableName'.

-- SELECT table_name
-- FROM information_schema.tables
-- WHERE table_name LIKE concat('tablename','%') AND table_schema = 'public'

-- Если нет, то создаем
-- CREATE TABLE TableName_del_1 (column_1 varchar,
-- 					   		     column_2 varchar);
					   
-- CREATE TABLE TableName_del_2 (column_1 varchar,
-- 					   		     column_2 varchar);

-- Вызываем процедуру
-- CALL delete_table ();

-- Еще раз проверяем запросом выше, что таких таблиц нет, то есть они удалились.


-- ////////////////// --


-- 2) Создать хранимую процедуру с выходным параметром, 
-- которая выводит список имен и параметров всех скалярных SQL функций пользователя в текущей базе данных. 
-- Имена функций без параметров не выводить. 
-- Имена и список параметров должны выводиться в одну строку. 
-- Выходной параметр возвращает количество найденных функций.

DROP PROCEDURE IF EXISTS get_scalar_functions_with_params();
CREATE OR REPLACE PROCEDURE get_scalar_functions_with_params(OUT function_count integer)
AS $$
DECLARE
    function_info text := '';
    function_row record;
BEGIN
    function_count := 0;

    FOR function_row IN
        SELECT p.proname AS function_name,
               pg_catalog.pg_get_function_arguments(p.oid) AS function_args
		FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
		    AND p.prokind = 'f'
            AND pg_catalog.pg_get_function_arguments(p.oid) <> ''
    LOOP
        function_count := function_count + 1;
        function_info := function_info || '
' || function_row.function_name || '(' || function_row.function_args || ')';
    END LOOP;

    RAISE NOTICE 'Function Info: %', function_info;
END;
$$ LANGUAGE plpgsql;

-- Проверяем работу процедуры - она вовзращает аут параметр - инт число функций 
-- И выводит через нотис списки функций 
-- DO $$
-- DECLARE
--     function_count integer; -- для записи числа функций 
-- BEGIN
--     CALL get_scalar_functions_with_params(function_count);
--     RAISE NOTICE 'Found functions: %', function_count; -- выводим параметр 
-- END;
-- $$;


-- ///////////////////--


-- 3) Создать хранимую процедуру с выходным параметром, которая уничтожает все SQL DML триггеры в текущей базе данных.
-- Выходной параметр возвращает количество уничтоженных триггеров.
DROP PROCEDURE IF EXISTS delete_triggers(OUT number_of_remote_triggers int);
CREATE OR REPLACE PROCEDURE delete_triggers(OUT number_of_remote_triggers int)
AS
$BODY$
DECLARE
    triger_name name;
	table_trigger_name name;
    sql_request text;
BEGIN
	SELECT COUNT(DISTINCT trigger_name) INTO number_of_remote_triggers
	FROM information_schema.triggers
	WHERE trigger_schema = 'public';

   	FOR triger_name, table_trigger_name IN (SELECT DISTINCT trigger_name, event_object_table
                         FROM information_schema.triggers
                         WHERE trigger_schema = 'public')
    	LOOP
        	sql_request := 'DROP TRIGGER ' || triger_name || ' ON ' || table_trigger_name ;
        	EXECUTE sql_request;
    	END LOOP;
END;
$BODY$
LANGUAGE plpgsql;

-- Проверяем есть ли в текущей базее данных тригеры
-- SELECT trigger_name
-- FROM information_schema.triggers

-- Смотрим количество триггеров если они есть
-- SELECT COUNT(DISTINCT trigger_name) AS amount_triggers
-- FROM information_schema.triggers
-- WHERE trigger_schema = 'public';

-- Вызываем процедуру и после отработки процедуры еще раз смотрим количесвто триггеров (пункт выше)
-- CALL delete_triggers(NULL);


-- ///////////////////// --


-- 4) Создать хранимую процедуру с входным параметром, которая выводит имена и описания типа объектов (только хранимых процедур и скалярных функций),
-- в тексте которых на языке SQL встречается строка, задаваемая параметром процедуры.
DROP PROCEDURE IF EXISTS finder_function_and_procedures(IN pattern varchar, IN ref refcursor);
CREATE OR REPLACE PROCEDURE finder_function_and_procedures(IN pattern varchar, IN ref refcursor)
AS
$BODY$
BEGIN
  OPEN ref FOR
            SELECT routine_name AS name, routine_type AS type
            FROM information_schema.routines
            WHERE specific_schema = 'public' AND routine_definition LIKE '%'||pattern||'%';
    END;
$BODY$ 
LANGUAGE plpgsql;

-- Проверяем работу процедуры. Процедура записывает данные в рефкурсор, дажее мы показываем что хранится в рефкурсоре
-- CALL finder_function_and_procedures('delete', 'ref');
-- FETCH ALL IN "ref";

