# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils flag-o-matic multilib user

DESCRIPTION="A fast Servlet and JSP engine"
HOMEPAGE="http://www.caucho.com"
SRC_URI="http://www.caucho.com/download/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
IUSE="admin doc"

KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/resin-servlet-api:3.0
	dev-java/jsr101:0
	dev-java/mojarra:1.2
	dev-java/oracle-javamail:0
	dev-java/validation-api:1.0
	dev-java/glassfish-xmlrpc-api:0
	dev-java/glassfish-deployment-api:1.2"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	dev-libs/openssl
	dev-java/ant-core:0
	${CDEPEND}"

RESIN_HOME="/usr/$(get_libdir)/resin"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="
jsr101
mojarra-1.2
oracle-javamail
validation-api-1.0
glassfish-xmlrpc-api
resin-servlet-api-3.0
glassfish-deployment-api-1.2"

PATCHES=(
	"${FILESDIR}"/"${PV}"/VarType.java.patch
	"${FILESDIR}"/"${PV}"/resin-compile.patch
	"${FILESDIR}"/"${PV}"/build.xml.patch
)

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup resin
	enewuser resin -1 /bin/bash ${RESIN_HOME} resin
}

src_prepare() {
	epatch "${PATCHES[@]}"

	# No bundled JARs!
	rm -f "${S}/modules/ext/"*.jar || die
	rm -rf "${S}/project-jars" || die

	java-ant_bsfix_one "${S}/build.xml"
	java-ant_bsfix_one "${S}/build-common.xml"

	rm -rf lib/* || die

	java-pkg_jar-from --into lib jsr101
	java-pkg_jar-from --into lib mojarra-1.2
	java-pkg_jar-from --into lib oracle-javamail
	java-pkg_jar-from --into lib validation-api-1.0
	java-pkg_jar-from --into lib glassfish-xmlrpc-api
	java-pkg_jar-from --into lib glassfish-deployment-api-1.2
	java-pkg_jar-from --into lib resin-servlet-api-3.0 resin-servlet-api.jar

	ln -s $(java-config --jdk-home)/lib/tools.jar || die
}

src_configure() {
	append-flags -fPIC -DPIC

	chmod 755 "${S}/configure" || die
	econf --prefix=${RESIN_HOME} || die "econf failed"
}

src_compile() {
	einfo "Building libraries..."
	emake || die "make failed"

	einfo "Building jars..."
	eant || die "ant failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	einfo "Moving configuration to /etc ..."
	dodir /etc/
	mv "${D}/${RESIN_HOME}/conf" "${D}/etc/resin" || die "mv of conf failed"
	dosym /etc/resin ${RESIN_HOME}/conf

	einfo "Rewriting resin.xml ..."
	sed -i \
		-e 's,${resin.root}/doc/resin-doc,webapps/resin-doc,' \
		-e 's,${resin.root}/doc/admin,webapps/admin,' \
		"${D}/etc/resin/resin.xml" || die

	einfo "Fixing log directory ..."
	rm -rf "${D}/${RESIN_HOME}/log" || die
	keepdir /var/log/resin
	dosym /var/log/resin ${RESIN_HOME}/log

	einfo "Installing basic documentation ..."
	dodoc README "${S}"/conf/*.xml

	einfo "Installing init.d script ..."
	newinitd "${FILESDIR}/${PV}/resin.init" resin
	newconfd "${FILESDIR}/${PV}/resin.conf" resin

	sed -i -e "s,__RESIN_HOME__,${RESIN_HOME},g" "${D}/etc/init.d/resin" || die

	einfo "Fixing location of jars ..."
	rm -f "${S}/lib/tools.jar" || die
	java-pkg_dojar "${S}"/lib/*.jar
	rm -fr "${D}/${RESIN_HOME}/lib" || die
	dosym /usr/share/resin/lib ${RESIN_HOME}/lib

	einfo "Symlinking directories from /var/lib/resin ..."
	rm -rf "${D}/${RESIN_HOME}/resin-data" || die
	rm -rf "${D}/${RESIN_HOME}/watchdog-data" || die
	dodir /var/lib/resin/webapps
	keepdir /var/lib/resin/hosts
	keepdir /var/lib/resin/resin-data
	keepdir /var/lib/resin/watchdog-data
	mv "${D}"/${RESIN_HOME}/webapps/* "${D}/var/lib/resin/webapps" || \
		die "mv of webapps failed"
	rm -rf "${D}/${RESIN_HOME}/webapps" || die
	dosym /var/lib/resin/webapps ${RESIN_HOME}/webapps
	dosym /var/lib/resin/hosts ${RESIN_HOME}/hosts
	dosym /var/lib/resin/resin-data ${RESIN_HOME}/resin-data
	dosym /var/lib/resin/watchdog-data ${RESIN_HOME}/watchdog-data

	dosym \
		"$(java-pkg_getjar resin-servlet-api-3.0 resin-servlet-api.jar)" \
		"${JAVA_PKG_JARDEST}/resin-servlet-api.jar"

	use admin && {
		einfo "Installing administration app ..."
		cp -a "${S}/doc/admin" "${D}/var/lib/resin/webapps/" || die
	}
	use doc && {
		einfo "Installing documentation app ..."
		cp -a "${S}/doc/resin-doc" "${D}/var/lib/resin/webapps/" || die
	}

	use source && {
		einfo "Installing sources ..."
		java-pkg_dosrc "${S}"/modules/*/src/* > /dev/null
	}

	einfo "Removing stale directories ..."
	rm -fr "${D}/${RESIN_HOME}/bin" || die
	rm -fr "${D}/${RESIN_HOME}/doc" || die
	rm -fr "${D}/${RESIN_HOME}/keys" || die
	rm -fr "${D}/${RESIN_HOME}/licenses" || die
	rm -fr "${D}/etc/resin/"*.orig || die

	einfo "Fixing ownerships and permissions ..."
	fowners -R 0:root /
	fowners -R resin:resin /etc/resin
	fowners -R resin:resin /var/lib/resin
	fowners -R resin:resin /var/log/resin

	fperms 644 /etc/conf.d/resin
	fperms 755 /etc/init.d/resin
	fperms 750 /var/lib/resin
	fperms 750 /etc/resin
}

pkg_postinst() {
	elog
	elog " User and group 'resin' have been added."
	elog
	elog " By default, Resin runs on port 8080. You can change this"
	elog " value by editing /etc/resin/resin.properties."
	elog
}
