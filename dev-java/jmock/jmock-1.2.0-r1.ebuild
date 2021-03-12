# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
SRC_URI="http://${PN}.org/downloads/${P}-jars.zip"
HOMEPAGE="http://jmock.org/"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

CDEPEND="dev-java/junit:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="junit"

src_unpack() {
	default
	unpack ${A}
	unzip "${S}"/"${PN}-core-${PV}.jar" -d src || die
	mv src "${S}" || die
}

java_prepare() {
	find -name "*.class" -delete || die
	rm *.jar || die

	# This patch isn't changing the behaviour if jmock per se.
	# Only the formatting is altered.
	epatch "${FILESDIR}"/"${P}-AbstractMo.patch"
}
