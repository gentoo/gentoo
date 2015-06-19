# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hsqldb/hsqldb-1.8.1.3.ebuild,v 1.8 2014/08/10 19:59:56 slyfox Exp $

EAPI=4
JAVA_PKG_IUSE="doc source test"
inherit eutils user versionator java-pkg-2 java-ant-2

MY_PV=$(replace_all_version_separators _ )
MY_P="${PN}_${MY_PV}"

DESCRIPTION="The leading SQL relational database engine written in Java"
HOMEPAGE="http://hsqldb.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-macos ~x64-solaris ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

CDEPEND="java-virtuals/servlet-api:2.3"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND="virtual/jdk:1.6
	test? ( dev-java/junit:0 )
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${PN}"

HSQLDB_JAR=/usr/share/hsqldb/lib/hsqldb.jar
HSQLDB_HOME=/var/lib/hsqldb

pkg_setup() {
	enewgroup hsqldb
	enewuser hsqldb -1 /bin/sh /dev/null hsqldb

	java-pkg-2_pkg_setup
}

src_prepare() {
	rm -v lib/*.jar || die
	java-pkg_jar-from --virtual --into lib servlet-api-2.3

	sed -i -r \
		-e "s#/etc/sysconfig#${EPREFIX}/etc/conf.d#g" \
		bin/hsqldb || die

	java-pkg_filter-compiler jikes

	eant -q -f "${EANT_BUILD_XML}" cleanall > /dev/null

	epatch "${FILESDIR}/resolve-config-softlinks.patch"

	mkdir conf
	sed -e "s/^HSQLDB_JAR_PATH=.*$/HSQLDB_JAR_PATH=${EPREFIX//\//\\/}${HSQLDB_JAR//\//\\/}/g" \
		-e "s/^SERVER_HOME=.*$/SERVER_HOME=${EPREFIX//\//\\/}\/var\/lib\/hsqldb/g" \
		-e "s/^HSQLDB_OWNER=.*$/HSQLDB_OWNER=hsqldb/g" \
		-e 's/^#AUTH_FILE=.*$/AUTH_FILE=${SERVER_HOME}\/sqltool.rc/g' \
		src/org/hsqldb/sample/sample-hsqldb.cfg > conf/hsqldb || die
	cp "${FILESDIR}/server.properties" conf/ || die
	cp "${FILESDIR}/sqltool.rc" conf/ || die

	# Missing source file - needed for tests
	# http://hsqldb.cvs.sourceforge.net/*checkout*/hsqldb/hsqldb-dev/src/org/hsqldb/lib/StringComparator.java?revision=1.1&pathrev=hsqldb_1_8_0_10
	# http://sourceforge.net/tracker/index.php?func=detail&aid=2008754&group_id=23316&atid=378131
	cp "${FILESDIR}/StringComparator.java" src/org/hsqldb/lib || die
	cp "${FILESDIR}/TestBug1191815.java" src/org/hsqldb/test/ || die
}

# EANT_BUILD_XML used also in src_unpack
EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="jar jarclient jarsqltool jarutil"
EANT_DOC_TARGET="javadocdev"

src_test() {
	java-pkg_jar-from --into lib junit
	eant -f ${EANT_BUILD_XML} jartest
	cd testrun/hsqldb || die
	./runTest.sh TestSelf || die "TestSelf hsqldb tests failed"
	# TODO. These fail. Investigate why.
	#cd "${S}/testrun/sqltool" || die
	#CLASSPATH="${S}/lib/hsqldb.jar" ./runtests.bash || die "sqltool test failed"
}

src_install() {
	java-pkg_dojar lib/hsql*.jar

	if use doc; then
		dodoc doc/*.txt
		dohtml -r doc/zaurus
		dohtml -r doc/src
	fi
	use source && java-pkg_dosrc src/*

	echo "CONFIG_PROTECT=\"${HSQLDB_HOME}\"" > "${T}"/35hsqldb || die
	doenvd "${T}"/35hsqldb

	# Put init, configuration and authorization files in /etc
	doinitd "${FILESDIR}/hsqldb"
	doconfd conf/hsqldb
	dodir /etc/hsqldb
	insinto /etc/hsqldb
	# Change the ownership of server.properties and sqltool.rc
	# files to hsqldb:hsqldb. (resolves Bug #111963)
	use prefix || insopts -m0600 -o hsqldb -g hsqldb
	doins conf/server.properties
	use prefix || insopts -m0600 -o hsqldb -g hsqldb
	doins conf/sqltool.rc

	# Install init script
	dodir "${HSQLDB_HOME}/bin"
	keepdir "${HSQLDB_HOME}"
	exeinto "${HSQLDB_HOME}/bin"
	doexe bin/hsqldb

	# Make sure that files have correct permissions
	use prefix || chown -R hsqldb:hsqldb "${ED}${HSQLDB_HOME}"
	chmod o-rwx "${ED}${HSQLDB_HOME}"

	# Create symlinks to authorization files in the server home dir
	# (required by the hqldb init script)
	insinto "${HSQLDB_HOME}"
	dosym /etc/hsqldb/server.properties "${HSQLDB_HOME}/server.properties"
	dosym /etc/hsqldb/sqltool.rc "${HSQLDB_HOME}/sqltool.rc"
}

pkg_postinst() {
	ewarn "If you intend to run Hsqldb in Server mode and you want to create"
	ewarn "additional databases, remember to put correct information in both"
	ewarn "'server.properties' and 'sqltool.rc' files."
	ewarn "(read the 'Init script Setup Procedure' section of the 'Chapter 3."
	ewarn "UNIX Quick Start' in the Hsqldb docs for more information)"
	echo
	elog "Example:"
	echo
	elog "${EPREFIX}/etc/hsqldb/server.properties"
	elog "============================="
	elog "server.database.1=file:xdb/xdb"
	elog "server.dbname.1=xdb"
	elog "server.urlid.1=xdb"
	elog
	elog "${EPREFIX}/etc/hsqldb/sqltool.rc"
	elog "======================"
	elog "urlid xdb"
	elog "url jdbc:hsqldb:hsql://localhost/xdb"
	elog "username sa"
	elog "password "
	echo
	elog "Also note that each hsqldb server can serve only up to 10"
	elog "different databases simultaneously (with consecutive {0-9}"
	elog "suffixes in the 'server.properties' file)."
	echo
	ewarn "For data manipulation use:"
	ewarn
	ewarn "# java -classpath ${EPREFIX}${HSQLDB_JAR} org.hsqldb.util.DatabaseManager"
	ewarn "# java -classpath ${EPREFIX}${HSQLDB_JAR} org.hsqldb.util.DatabaseManagerSwing"
	ewarn "# java -classpath ${EPREFIX}${HSQLDB_JAR} org.hsqldb.util.SqlTool \\"
	ewarn "  --rcFile ${EPREFIX}/var/lib/hsqldb/sqltool.rc <dbname>"
	echo
	elog "The Hsqldb can be run in multiple modes - read 'Chapter 1. Running'"
	elog "and Using Hsqldb' in the Hsqldb docs at:"
	elog "  http://hsqldb.org/web/hsqlDocsFrame.html"
	elog "If you intend to run it in the Server mode, it is suggested to add the"
	elog "init script to your start-up scripts, this should be done like this:"
	elog "  \`rc-update add hsqldb default\`"
	echo
}
