drop function base64encode;
drop function base64decode;

create function base64encode returns string soname 'mysql_udf_base64.so';
create function base64decode returns string soname 'mysql_udf_base64.so';
