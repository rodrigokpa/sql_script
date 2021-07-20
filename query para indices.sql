select SERVERPROPERTY('servername'), DB_NAME(), OBJECT_SCHEMA_NAME(object_id), OBJECT_NAME(object_id), OBJECT_ID from sys.indexes where OBJECT_SCHEMA_NAME(object_id) <> 'sys'


