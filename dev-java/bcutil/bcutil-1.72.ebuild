# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcutil-jdk18on:1.72"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java APIs for ASN.1 extension and utility APIs used to support bcpkix and bctls"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

CDEPEND="~dev-java/bcprov-${PV}:0"
DEPEND="${CDEPEND}
	>=virtual/jdk-11:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index}.html )

S="${WORKDIR}/bc-java-r${PV/./rv}/util"

JAVA_GENTOO_CLASSPATH="bcprov"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/jdk1.9"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_RUN_ONLY=(
	"org.bouncycastle.asn1.util.test.AllTests"
	"org.bouncycastle.oer.test.AllTests"
)

src_prepare() {
	default
	java-pkg_clean ..
}

src_install() {
	docinto html
	dodoc -r ../docs
	java-pkg-simple_src_install
}
