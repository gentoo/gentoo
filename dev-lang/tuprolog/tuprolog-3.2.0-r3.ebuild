# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

PATCHSET_VER="0"

DESCRIPTION="tuProlog is a light-weight Prolog for Internet applications and infrastructures"
HOMEPAGE="http://tuprolog.unibo.it/"
SRC_URI="https://dev.gentoo.org/~keri/distfiles/tuprolog/${P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/tuprolog/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="LGPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="
	dev-java/commons-lang:3.6
	dev-java/gson:0
	dev-java/javassist:3
"

DEPEND="${CP_DEPEND}
	virtual/jdk:1.8
	test? (
		dev-java/hamcrest:0
		dev-java/junit:4
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=( "${WORKDIR}/${PV}" )

JAVA_GENTOO_CLASSPATH_EXTRA="lib/autocomplete.jar"
JAVA_GENTOO_CLASSPATH="
	commons-lang-3.6
	gson
	javassist-3
"
JAVA_RESOURCE_DIRS="res/src"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="
	hamcrest
	javassist-3
	junit-4
"
JAVA_TEST_RESOURCE_DIRS="test"
JAVA_TEST_RUN_ONLY=(
	alice.tuprolog.TuPrologTestSuite
	alice.tuprolog.ExceptionsTestSuite
)
JAVA_TEST_SRC_DIR="test/unit/alice"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	mkdir res || die
	find src -type f ! -name '*.java' \
		| xargs cp --parents -t res || die

	# unpack for bundling in 2p.jar
	jar xf lib/autocomplete.jar || die
	jar xf lib/rsyntaxtextarea.jar || die
}

src_install() {
	java-pkg-simple_src_install
	cp {tuprolog,2p}.jar || die

	# these were bundled already in previous revision
	jar uf 2p.jar -C . org theme.dtd || die
	java-pkg_dojar 2p.jar

	if use examples ; then
		docinto examples
		dodoc doc/examples/*.pl
	fi
}
