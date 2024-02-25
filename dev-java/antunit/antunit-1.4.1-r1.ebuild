# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ant.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-ant )"
# reset to ant-core:0 when ready
CP_DEPEND="
	>=dev-java/ant-1.10.14:0
	dev-java/junit:4
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( >=dev-java/ant-1.10.14:0[junit,testutil] )
"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE README WHATSNEW )
HTML_DOCS=( README.html )
PATCHES=(
	# Some tests expect classes in "build" instead in "target" directory.
	"${FILESDIR}/antunit-1.4.1-gentoo.patch"
)

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src/main"
JAVA_TEST_GENTOO_CLASSPATH="ant"
JAVA_TEST_SRC_DIR="src/tests/junit"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir -p "res/org/apache/ant/antunit" || die
	cp {src/main,res}/org/apache/ant/antunit/antlib.xml || die
}
