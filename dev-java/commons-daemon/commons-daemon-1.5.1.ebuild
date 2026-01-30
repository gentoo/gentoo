# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 toolchain-funcs verify-sig

DESCRIPTION="Tools to allow Java programs to run as UNIX daemons"
HOMEPAGE="https://commons.apache.org/proper/commons-daemon/"
SRC_URI="mirror://apache/commons/daemon/source/${P}-src.tar.gz
	verify-sig? ( mirror://apache/commons/daemon/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/junit:5[-vintage]
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {HOWTO-RELEASE,NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( PROPOSAL.html )
PATCHES=(
	"${FILESDIR}/commons-daemon-1.3.1-Make.patch"
	"${FILESDIR}/commons-daemon-1.5.1-gentoo.patch"
)

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-5 opentest4j"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-simple_src_compile
	cd src/native/unix || die
	./configure
	emake AR="$(tc-getAR)"
}

src_install() {
	java-pkg-simple_src_install
	dobin src/native/unix/jsvc
}
