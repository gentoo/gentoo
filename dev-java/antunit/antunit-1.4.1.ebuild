# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.ant:ant-antunit:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="An Antlib that provides a test framework for Apache Ant tasks and types"
HOMEPAGE="https://ant.apache.org/antlibs/antunit/"
SRC_URI="mirror://apache/ant/antlibs/${PN}/source/apache-ant-${P}-src.tar.bz2
	verify-sig? ( https://downloads.apache.org/ant/antlibs/antunit/source/apache-ant-${P}-src.tar.bz2.asc )"
S="${WORKDIR}/apache-ant-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ant.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-ant )"
# reset to ant-core:0 when ready
CP_DEPEND="
	dev-java/ant-core:0
	dev-java/junit:4
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-testutil:0
	)
"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE README WHATSNEW )
HTML_DOCS=( README.html )

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="ant-testutil"
JAVA_TEST_SRC_DIR="src/tests/junit"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p "res/org/apache/ant/antunit" || die
	cp {src/main,res}/org/apache/ant/antunit/antlib.xml || die

	# Some tests expect classes in "build" instead in "target" directory.
	sed -e 's:build\(/classes\):target\1:' \
		-i src/etc/testcases/assert.xml \
		-i src/tests/junit/org/apache/ant/antunit/AssertTest.java || die
	sed -e 's:build\(/test-classes\):target\1:' \
		-i src/etc/testcases/antunit/java-io.xml || die
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 21; then
		eapply "${FILESDIR}/antunit-1.4.1-AntUnitTest.patch"
		# java.lang.UnsupportedOperationException:
		# The Security Manager is deprecated and will be removed in a future release
		JAVA_TEST_EXCLUDES="org.apache.ant.antunit.junit3.EatYourOwnDogFoodTest"
	fi
	java-pkg-simple_src_test
}
