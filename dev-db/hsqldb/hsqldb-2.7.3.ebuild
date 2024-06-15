# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.hsqldb:hsqldb:${PV}"

inherit java-pkg-2

MY_PV="$(ver_cut 1-2)"
MY_PV="${MY_PV//./_}"

DESCRIPTION="HSQLDB - Lightweight 100% Java SQL Database Engine"
HOMEPAGE="https://hsqldb.org"
SRC_URI="https://downloads.sourceforge.net/project/hsqldb/hsqldb/hsqldb_${MY_PV}/${P}.zip"
S="${WORKDIR}/${P}/${PN}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	app-arch/unzip
	>=dev-java/ant-1.10.14-r3:0
"

COMMON_DEPEND="
	acct-group/hsqldb
	acct-user/hsqldb
"

DEPEND="${COMMON_DEPEND}
	dev-java/javax-servlet-api:3.1
	>=virtual/jdk-11:*
	test? (
		>=dev-java/ant-1.10.14-r3:0[junit]
		dev-java/junit:0
	)"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-11:*"

DOCS=( readme.txt doc/{changelist_2_0,odbc,readme-docauthors}.txt )

PATCHES=(
	"${FILESDIR}/hsqldb-2.7.3-hsqldb.conf.patch"
	"${FILESDIR}/hsqldb-2.7.3-hsqldb.init.patch"
)

HSQLDB_JAR=/usr/share/hsqldb/lib/hsqldb.jar
HSQLDB_HOME=/var/lib/hsqldb

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	# bin/hsqldb seems to have moved/renamed to sample/hsqldb.init
	mv sample/hsqldb{.init,} || die

	mkdir conf
	# sample-hsqldb.cfg seems to have moved/renamed to sample/hsqldb.conf
	mv sample/hsqldb.conf conf/hsqldb || die

	cp "${FILESDIR}/server.properties" conf/ || die
	cp "${FILESDIR}/sqltool.rc" conf/ || die
}

src_compile() {
	local targets=( hsqldb hsqldbutil sqltool )
	if use doc; then
		mkdir doc-src/apidocs || die
		cp doc{,-src}/apidocs/javadoc.css || die
		rm -r doc/apidocs || die
		targets+=( javadoc )
	fi
	use test && targets+=( preprocessor )
	eant \
		-f build/build.xml \
		-Dservletapi.lib="$(java-pkg_getjars --build-only javax-servlet-api-3.1)" \
		-Djavac.bootcp.override \
		-Dant.java.iscjava11 \
		-Dant.build.javac.source="11" \
		-Dant.build.javac.target="11" \
		"${targets[@]}"
}

src_test() {
	mkdir -p test-src/org/hsqldb/{resources,jdbc/resources/{xml,sql},util/preprocessor} || die
	eant -v \
		-f build/test.xml \
		-Dservletapi.lib="$(java-pkg_getjars --build-only javax-servlet-api-3.1)" \
		-Djunit.jar="$(java-pkg_getjars --build-only junit)" \
		-Djavac.bootcp.override \
		-Dant.java.iscjava11 \
		-Dant.build.javac.source="11" \
		-Dant.build.javac.target="11" \
		make.test.suite run.test.suite
}

src_install() {
	java-pkg_dojar lib/{hsqldb{,util},sqltool}.jar

	einstalldocs
	use doc && java-pkg_dojavadoc doc/apidocs

	use source && java-pkg_dosrc src/*

	echo "CONFIG_PROTECT=\"${HSQLDB_HOME}\"" > "${T}"/35hsqldb || die
	doenvd "${T}"/35hsqldb

	# Put init, configuration and authorization files in /etc
	doinitd "${FILESDIR}/hsqldb"
	doconfd conf/hsqldb
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
	doexe sample/hsqldb

	# Make sure that files have correct permissions
	use prefix || chown -R hsqldb:hsqldb "${ED}${HSQLDB_HOME}" || die
	chmod o-rwx "${ED}${HSQLDB_HOME}" || die

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
