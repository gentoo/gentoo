# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
HOMEPAGE="http://jmock.org/"
SRC_URI="http://jmock.org/downloads/${P}-jars.zip"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

CDEPEND="dev-java/junit:0"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="junit"

PATCHES=(
	# This patch isn't changing the behaviour if jmock per se.
	# Only the formatting is altered.
	"${FILESDIR}"/${P}-AbstractMo.patch
)

src_unpack() {
	unpack ${A}
	unzip "${P}"/jmock-core-"${PV}".jar -d src || die
	mv src "${P}" || die
}

src_prepare() {
	default
	find -name "*.class" -delete || die
	rm *.jar || die
}
