# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
DESCRIPTION="Guacamole is a html5 vnc client as servlet"
HOMEPAGE="http://guacamole.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-client-${PV}.tar.gz
	mysql? ( http://sourceforge.net/projects/${PN}/files/current/extensions/${PN}-auth-mysql-0.9.0.tar.gz )
	ldap? ( http://sourceforge.net/projects/guacamole/files/current/extensions/guacamole-auth-ldap-0.9.0.tar.gz )"
S="${WORKDIR}/${PN}-client-${PV}"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~x86"

IUSE="ldap mysql"

DEPEND="dev-java/maven-bin"

RDEPEND="${DEPEND}
	www-servers/tomcat
	>virtual/jre-1.6
	net-misc/guacamole-server
	mysql? ( virtual/mysql )
	ldap? ( net-nds/openldap )"

src_compile() {
	mkdir "${HOME}"/.m2
	cat /usr/share/`readlink /usr/bin/mvn | sed 's:mvn:maven-bin:'`/conf/settings.xml | \
	sed -e 's:/path/to/local/repo:'${HOME}/.m2':g' -e 's:<!-- localRepo::' >"${S}"/settings.xml
	mvn -s "${S}"/settings.xml package
}

src_install() {
	if use mysql; then
		echo lib-directory: "/var/lib/${PN}/classpath" >>"${S}/${PN}/doc/example/${PN}.properties"
		echo auth-provider: net.sourceforge.guacamole.net.auth.mysql.MySQLAuthenticationProvider >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-port: 3306 >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-database: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-username: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		echo mysql-password: some_password >>"${S}/${PN}/doc/example/${PN}.properties"
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/var/lib/${PN}/classpath"
		find "${WORKDIR}/${PN}-auth-mysql-0.9.0/lib/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema"
		find "${WORKDIR}/${PN}-auth-mysql-0.9.0/schema/" -name '*.sql' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema/upgrade"
		find "${WORKDIR}/${PN}-auth-mysql-0.9.0/schema/upgrade/" -name '*.sql' -exec doins '{}' +
		elog "Please add a mysql database and a user and load the sql files in /usr/share/guacamole/schema/ into it."
		elog "You will also need to adjust the DB propeties in /etc/guacamole.properties!"
		elog "The default user and it's password is \"guacadmin\"."
		elog "You will also need to download the mysql-connector from here http://dev.mysql.com/downloads/connector/j/"
		elog "and put the contained .jar file into /var/lib/guacamole/classpath!"
		elog "-"
	fi
	if use ldap; then
		echo lib-directory: "/var/lib/${PN}/classpath" >>"${S}/${PN}/doc/example/${PN}.properties"
		echo auth-provider: net.sourceforge.guacamole.net.auth.ldap.LDAPAuthenticationProvider >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-port: 389 >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-user-base-dn: ou=people,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-username-attribute: uid >>"${S}/${PN}/doc/example/${PN}.properties"
		echo ldap-config-base-dn: ou=groups,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/var/lib/${PN}/classpath"
		find "${WORKDIR}/${PN}-auth-ldap-0.9.0/lib/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema"
		doins "${WORKDIR}/${PN}-auth-ldap-0.9.0/schema/guacConfigGroup.ldif" "${WORKDIR}/${PN}-auth-ldap-0.9.0/schema/guacConfigGroup.schema"
		elog "You will need to add and load the .schema file in /usr/share/guacamole/schema/ to your ldap server."
		elog "There is also an example .lidf file for creating the users."
		elog "-"
	fi
	sed -e 's:/path/to:/etc/guacamole:g' -i "${S}/${PN}/doc/example/${PN}.properties" || die "properties sed failed"
	insinto /etc/"${PN}"
	doins "${S}/${PN}/doc/example/guacamole.properties"
	doins "${S}/${PN}/doc/example/user-mapping.xml"
	insinto "/var/lib/${PN}"
	newins "${S}/${PN}/target/${P}.war" "${PN}.war"
	elog "Please unpack /var/lib/"${PN}"/"${PN}".war in to your servlet container! If it is an update,"
	elog "delete the old content first!"
	elog "Read: if you use the command below, delete everything within /var/lib/guacamole/guacamole first!"
	elog "Please also link /etc/guacamole in to the lib directory of your servlet container."
	elog "like this:"
	elog "cd /var/lib/guacamole && mkdir guacamole && cd guacamole && jar -xvf ../guacamole.war && cd .. && mv guacamole /var/lib/tomcat-7/webapps/"
	elog "ln -sf /etc/guacamole/guacamole.properties /usr/share/tomcat-7/lib/"
	elog "You will also need to define users and connections in /etc/guacamole/user-mapping.xml if mysql is not used!"
}
