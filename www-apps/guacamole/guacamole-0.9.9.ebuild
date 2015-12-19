# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
DESCRIPTION="Guacamole is a html5 vnc client as servlet"
HOMEPAGE="http://guac-dev.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-client-${PV}.tar.gz"
S="${WORKDIR}/${PN}-client-${PV}"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="ldap mysql noauth postgres"

REQUIRED_USE="|| ( ldap mysql noauth postgres )"

DEPEND="dev-java/maven-bin:*"

RDEPEND="${DEPEND}
	www-servers/tomcat[websockets]
	>virtual/jre-1.6
	net-misc/guacamole-server
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ldap? ( net-nds/openldap )"

src_compile() {
	mkdir "${HOME}"/.m2
	cat /usr/share/`readlink /usr/bin/mvn | sed 's:mvn:maven-bin:'`/conf/settings.xml | \
	sed -e 's:/path/to/local/repo:'${HOME}/.m2':g' -e 's:<!-- localRepo::' >"${S}"/settings.xml
	mvn -s "${S}"/settings.xml package
}

src_install() {
	echo guacd-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
	echo guacd-port:     4822 >>"${S}/${PN}/doc/example/${PN}.properties"
	echo basic-user-mapping: /etc/guacamole/user-mapping.xml >>"${S}/${PN}/doc/example/${PN}.properties"
	if use mysql || use postgres; then
		insinto "/etc/${PN}/extensions"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-base/" -name '*.jar' -exec doins '{}' +
	fi
	if use noauth; then
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		echo noauth-config: /etc/guacamole/noauth-config.xml  >>"${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-noauth/" -name '*.jar' -exec doins '{}' +
		insinto "/etc/guacamole"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-noauth/doc/example/" -name '*.xml' -exec doins '{}' +
		elog "Warning: Setting No Authentication is obviously very insecure! Only use it if you know what you are doing!"
	fi
	if use mysql; then
		echo mysql-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-port: 3306 >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-database: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-username: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-password: some_password >>"${S}/${PN}/doc/example/${PN}.properties"
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-mysql/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema/mysql"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-mysql/schema/" -name '*.sql' -exec doins '{}' +
		elog "Please add a mysql database and a user and load the sql files in /usr/share/guacamole/schema/ into it."
		elog "If this is an update, then you will need to apply the appropriate update script in the location above."
		elog "You will also need to adjust the DB propeties in /etc/guacamole.properties!"
		elog "The default user and it's password is \"guacadmin\"."
		elog "You will also need to download the mysql-connector from here http://dev.mysql.com/downloads/connector/j/"
		elog "and put the contained .jar file into /etc/guacamole/lib!"
		elog "-"
	fi
	if use postgres; then
		echo postgresql-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		echo postgresql-port: 5432 >>"${S}/${PN}/doc/example/${PN}.properties"
		echo postgresql-database: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo postgresql-username: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo postgresql-password: some_password >>"${S}/${PN}/doc/example/${PN}.properties"
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-postgresql/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema/postgres"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-postgresql/schema/" -name '*.sql' -exec doins '{}' +
		elog "Please add a postgresql database and a user and load the sql files in /usr/share/guacamole/schema/ into it."
		elog "If this is an update, then you will need to apply the appropriate update script in the location above."
		elog "You will also need to adjust the DB propeties in /etc/guacamole.properties!"
		elog "The default user and it's password is \"guacadmin\"."
		elog "You will also need to download the postgresql-connector from here https://jdbc.postgresql.org/download.html#current"
		elog "and put the contained .jar file into /etc/guacamole/lib!"
		elog "-"
	fi
	if use ldap; then
		echo ldap-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-port: 389 >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-user-base-dn: ou=people,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-username-attribute: uid >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-config-base-dn: ou=groups,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-ldap" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema"
		doins "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-ldap/schema/guacConfigGroup.ldif" "${WORKDIR}/${PN}-client-${PV}/extensions/${PN}-auth-ldap/schema/guacConfigGroup.schema"
		elog "You will need to add and load the .schema file in /usr/share/guacamole/schema/ to your ldap server."
		elog "There is also an example .lidf file for creating the users."
		elog "-"
	fi
	insinto "/etc/${PN}"
	doins "${WORKDIR}/${PN}-client-${PV}/${PN}/doc/example/user-mapping.xml"
	insinto "/etc/${PN}"
	doins "${S}/${PN}/doc/example/guacamole.properties"
	echo "GUACAMOLE_HOME=/etc/guacamole" >98guacamole
	doenvd 98guacamole
	insinto "/var/lib/${PN}"
	newins "${S}/${PN}/target/${P}.war" "${PN}.war"
	elog "If it is an update, please make sure to delete the old webapp in /var/lib/tomcat-7/webapps/ first!"
	elog "To deploy guacamole with tomcat, you will need to link the war file and create the configuration!"
	elog "ln -sf /var/lib/${PN}/${PN}.war /var/lib/tomcat-7-main/webapps/"
	elog "You will also need to adjust the configuration in /etc/${PN}/${PN}.properties"
	elog "See http://guac-dev.org/doc/${PV}/gug/configuring-guacamole.html#initial-setup for a basic setup"
	elog "or http://guac-dev.org/doc/${PV}/gug/jdbc-auth.html for a database for authentication and host definitions."
}
