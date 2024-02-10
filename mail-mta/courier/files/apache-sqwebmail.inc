Alias /webmail/ /usr/share/courier/sqwebmail/images/
<Directory /usr/share/courier/sqwebmail/>
	Order Allow,Deny
	AllowOverride All
	Allow from all
</Directory>

ScriptAlias /courier/ /usr/lib/courier/courier/webmail/
<Directory /usr/lib/courier/courier/webmail/>
	AllowOverride All
	Options ExecCGI
	Order allow,deny
	Allow from all
</Directory>
