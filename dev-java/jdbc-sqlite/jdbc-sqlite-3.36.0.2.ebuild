# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xerial:sqlite-jdbc:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

MY_PV="$(ver_cut 1-3)"
A_PV="$( printf "%u%02u%02u00" ${MY_PV//./ } )"
DESCRIPTION="SQLite JDBC library"
HOMEPAGE="https://github.com/xerial/sqlite-jdbc"
SRC_URI="https://github.com/xerial/sqlite-jdbc/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://www.sqlite.org/2021/sqlite-amalgamation-${A_PV}.zip"
S="${WORKDIR}/sqlite-jdbc-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

DOCS=(
	CHANGELOG
	NOTICE
	README.md
	Usage.md
)

PATCHES=(
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-OSInfo.patch"
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-Makefile-noHeader.patch"
	# Need to try external archive amalgamation
	# https://github.com/xerial/sqlite-jdbc/pull/466
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-Makefile-noDownload.patch"
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-Makefile-tempdir.patch"
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-ConnectionTest.patch"
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-SQLiteJDBCLoaderTest.patch"
	"${FILESDIR}/jdbc-sqlite-3.36.0.2-JDBCTest.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.xerial.sqlitejdbc"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RUN_ONLY="org.sqlite.AllTests"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	java-pkg-2_src_prepare
	# Keep src/test/resources/org/sqlite/testdb.jar
	java-pkg_clean ! -path "./src/*"

	# Move unpacked sqlite-amalgamation to target
	mkdir -v target || die
	mv -v "${WORKDIR}/sqlite-amalgamation-${A_PV}" target || die
	touch target/sqlite-unpack.log || die

	# Remove pre-built native libraries
	rm -r "${JAVA_RESOURCE_DIRS}/org" || die

	# Move java.sql.Driver to services directory
	mkdir -p "${JAVA_RESOURCE_DIRS}/META-INF/services" || die
	mv src/main/resources/{,META-INF/services/}java.sql.Driver || die

	# org.junit.ComparisonFailure: driver name expected:<[SQLite JDBC]> but was:<[${project.name}]>
	sed -e "s:\${project.name}:SQLite JDBC: ; s:\${project.version}:${PV}:" \
		-i src/main/resources/sqlite-jdbc.properties || die

	cat > "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF" <<-EOF || die
		Bundle-SymbolicName: org.xerial.sqlite-jdbc;singleton:=true
		Bundle-Version: ${PV}
		Import-Package: javax.sql;resolution:=optional
	EOF

	# Avoid calling gcc directly
	sed -e 's:)gcc:)${GCC}:' -i Makefile.common || die
	sed -e '/^MVN:/i GCC ?= gcc' -i Makefile || die
}

src_compile() {
	einfo "Compiling OSInfo.java"
	ejavac -d lib -classpath "${JAVA_SRC_DIR}" \
		"${JAVA_SRC_DIR}/org/sqlite/util/OSInfo.java" || die

	einfo "Generating header"
	# Creates ./target/common-lib/org_sqlite_core_NativeDB.h
	ejavac -h target/common-lib -classpath "${JAVA_SRC_DIR}" \
		"${JAVA_SRC_DIR}/org/sqlite/core/NativeDB.java" || die

	# make: *** No rule to make target 'target/common-lib/NativeDB.h',
	# needed by 'target/sqlite-3.41.2-Linux-x86_64/libsqlitejdbc.so'.  Stop.
	mv -v target/common-lib/{org_sqlite_core_,}NativeDB.h || die

	einfo "Building native library"
	local args=(
		GCC="$(tc-getCC)"
		STRIP="$(tc-getSTRIP)"
		)
	# Builds the native library and puts it in the ARCH specific directory.
	# ${JAVA_RESOURCE_DIRS}/org/sqlite/native/Linux/x86_64/libsqlitejdbc.so
	emake "${args[@]}" native

	einfo "Compiling Java"
	java-pkg-simple_src_compile
}
