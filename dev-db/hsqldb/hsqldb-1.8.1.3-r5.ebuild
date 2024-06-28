# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PV=$(ver_rs 1- '_')
MY_P="${PN}_${MY_PV}"

DESCRIPTION="The leading SQL relational database engine written in Java"
HOMEPAGE="https://hsqldb.org"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.zip"
S="${WORKDIR}/${PN}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

CDEPEND="
	acct-group/hsqldb
	acct-user/hsqldb
	dev-java/jakarta-servlet-api:4"
RDEPEND="${CDEPEND}
	virtual/jre:1.8"
DEPEND="${CDEPEND}
	virtual/jdk:1.8
	test? ( dev-java/junit:0 )"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/resolve-config-softlinks.patch"
	"${FILESDIR}/${P}-java7.patch"
)

HSQLDB_JAR=/usr/share/hsqldb/lib/hsqldb.jar
HSQLDB_HOME=/var/lib/hsqldb

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_prepare() {
	default
	rm -v lib/*.jar || die

	sed -i -r \
		-e "s#/etc/sysconfig#${EPREFIX}/etc/conf.d#g" \
		bin/hsqldb || die

	java-pkg_filter-compiler jikes

	eant -q -f "${EANT_BUILD_XML}" cleanall > /dev/null

	mkdir conf
	sed -e "s/^HSQLDB_JAR_PATH=.*$/HSQLDB_JAR_PATH=${EPREFIX//\//\\/}${HSQLDB_JAR//\//\\/}/g" \
		-e "s/^SERVER_HOME=.*$/SERVER_HOME=${EPREFIX//\//\\/}\/var\/lib\/hsqldb/g" \
		-e "s/^HSQLDB_OWNER=.*$/HSQLDB_OWNER=hsqldb/g" \
		-e 's/^#AUTH_FILE=.*$/AUTH_FILE=${SERVER_HOME}\/sqltool.rc/g' \
		src/org/hsqldb/sample/sample-hsqldb.cfg > conf/hsqldb || die
	cp "${FILESDIR}/server.properties" conf/ || die
	cp "${FILESDIR}/sqltool.rc" conf/ || die

	# Missing source file - needed for tests
	# https://sourceforge.net/p/hsqldb/svn/HEAD/tree/base/trunk/src/org/hsqldb/lib/StringComparator.java
	# https://sourceforge.net/p/hsqldb/bugs/815/
	cp "${FILESDIR}/StringComparator.java" src/org/hsqldb/lib || die
	cp "${FILESDIR}/TestBug1191815.java" src/org/hsqldb/test/ || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

# EANT_BUILD_XML used also in src_prepare
EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="jar jarclient jarsqltool jarutil"
EANT_DOC_TARGET="javadocdev"
EANT_GENTOO_CLASSPATH="jakarta-servlet-api-4"

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
	java-pkg_dojar lib/hsql{db{,util},tool,jdbc}.jar

	if use doc; then
		dodoc doc/*.txt
		docinto html
		dodoc -r doc/{src,zaurus}
	fi
	use source && java-pkg_dosrc src/*

	echo "CONFIG_PROTECT=\"${HSQLDB_HOME}\"" > "${T}"/35hsqldb || die
	doenvd "${T}"/35hsqldb

	# Put init, configuration and authorization files in /etc
	doinitd "${FILESDIR}/hsqldb"
	doconfd conf/hsqldb
#	dodir /etc/hsqldb
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
	dosym ../../../etc/hsqldb/server.properties "${HSQLDB_HOME}/server.properties"
	dosym ../../../etc/hsqldb/sqltool.rc "${HSQLDB_HOME}/sqltool.rc"
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
