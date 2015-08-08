# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java spell-checking library"
HOMEPAGE="https://www.inetsoftware.de/other-products/jortho"
SRC_URI="mirror://sourceforge/project/jortho/JOrtho%20Library/${PV}/JOrtho_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

java_prepare() {
	find . -name '*.jar' -exec rm -v {} + || die
}

JAVA_SRC_DIR="src/com"
src_compile() {
	mkdir -p target/classes/com/inet/jortho/i18n || die
	find src -name '*.properties' \
		-exec cp {} target/classes/com/inet/jortho/i18n \; || die

	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install

	use examples && java-pkg_doexamples src/SampleAppl{et,ication}.java
}
