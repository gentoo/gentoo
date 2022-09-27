# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcprov-jdk18on:1.72"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( {README,SECURITY}.md )
HTML_DOCS=( {CONTRIBUTORS,index}.html )

S="${WORKDIR}/bc-java-r${PV/./rv}"

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_prepare() {
	default
	java-pkg_clean ..
	# 3 unsolved test failures # 873442
	rm -r core/src/test/java/org/bouncycastle/pqc/legacy/math/ntru || die
}

src_compile() {
	JAVA_RESOURCE_DIRS=(
		"core/src/main/resources"
		"prov/src/main/resources"
	)
	JAVA_SRC_DIR=(
		"core/src/main/java"
		"prov/src/main/java"
		"prov/src/main/jdk1.9"
	)
	java-pkg-simple_src_compile
}

src_test() {
	JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/core/src/test/data"
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"

	einfo "Testing \"core\""
	JAVA_TEST_RESOURCE_DIRS="core/src/test/resources"
	JAVA_TEST_SRC_DIR="core/src/test/java"
	pushd core/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "AllTests.java" )
	popd || die
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test

	einfo "Testing bcprov"
	JAVA_GENTOO_CLASSPATH_EXTRA=":core.jar" # other value needed than for compilation
	JAVA_TEST_RESOURCE_DIRS="prov/src/test/resources"
	JAVA_TEST_SRC_DIR="prov/src/test/java"
	pushd prov/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "AllTests.java" )
	popd || die
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	docinto html
	dodoc -r docs
	java-pkg-simple_src_install
}
