# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provides Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="http://www.easymock.org/"
SRC_URI="mirror://sourceforge/${PN}/EasyMock/${PV}/${P}.zip"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="3.2"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/junit:4
	dev-java/objenesis:0
	dev-java/cglib:3"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="junit-4,objenesis,cglib-3"
JAVA_SRC_DIR="src"

src_unpack() {
	default

	cd "${S}" || die
	unzip ${P}-sources.jar -d src/ || die

	if use examples; then
		unzip ${P}-samples.jar -d examples/ || die
	fi
}

java_prepare() {
	epatch "${FILESDIR}"/${PV}-no-android.patch
	rm src/org/easymock/internal/AndroidClassProxyFactory.java || die
}

src_install() {
	java-pkg-simple_src_install

	use examples && java-pkg_doexamples examples
}
