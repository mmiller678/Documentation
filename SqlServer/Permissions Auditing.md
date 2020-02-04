# View members for all database roles

```
SELECT 
	dp.name AS DatabaseRoleName,  
	ISNULL(dp2.name, 'No members') AS DatabaseUserName   
FROM sys.database_role_members AS drm  
RIGHT OUTER JOIN sys.database_principals AS dp ON drm.role_principal_id = dp.principal_id  
LEFT OUTER JOIN sys.database_principals AS dp2  ON drm.member_principal_id = dp2.principal_id  
WHERE 
	dp.type = 'R'
ORDER BY dp.name;
```

# View permissions for all database objects (views, stored procedures, schema, etc.)
```
SELECT
    dp.NAME AS principal_name, 
	dp.type_desc AS principal_type_desc, 
	s.name AS schema_name,
	o.NAME AS object_name,
	o.type_desc,
	p.class_desc,
    p.permission_name,
	p.state_desc AS permission_state_desc
FROM sys.all_objects o
JOIN sys.database_permissions p ON o.OBJECT_ID=p.major_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
LEFT OUTER JOIN sys.database_principals  dp ON p.grantee_principal_id = dp.principal_id
WHERE
	o.is_ms_shipped = 0 
ORDER BY schema_name, object_name
```

# View the current users permissions
```
SELECT 
	all_permissions.entity_class,
	all_permissions.schema_name,
	all_permissions.name,
	all_permissions.subentity_name,
	all_permissions.permission_name
FROM   (SELECT 'OBJECT' AS entity_class, s.name AS schema_name, o.name, p.subentity_name, p.permission_name
        FROM sys.objects o
		JOIN sys.schemas s ON o.schema_id = s.schema_id
        CROSS APPLY sys.fn_my_permissions(QUOTENAME(o.name), 'OBJECT') p
        UNION ALL
        SELECT 'DATABASE' AS entity_class, '', d.name, p.subentity_name, p.permission_name
        FROM   sys.databases d
        CROSS APPLY sys.fn_my_permissions(QUOTENAME(d.name), 'DATABASE') p
        UNION ALL
        SELECT 'SERVER' AS entity_class, '', @@SERVERNAME AS name, subentity_name, permission_name
        FROM  sys.fn_my_permissions(NULL, 'SERVER') p) all_permissions
ORDER  BY 
	entity_class,
	name
```

# Impersonate another user
Use EXECUTE AS USER and  REVERT
```
EXECUTE AS USER = 'WEISSASSET\John.Doe';  
SELECT CURRENT_USER
  SELECT * FROM fn_my_permissions('PL_CalculateByStrategy', 'OBJECT')   
REVERT;
```
