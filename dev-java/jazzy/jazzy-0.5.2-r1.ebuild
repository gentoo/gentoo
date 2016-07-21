# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Spell Check API"
HOMEPAGE="http://sourceforge.net/projects/jazzy"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"

DEPEND=">=virtual/jdk-1.6
		app-arch/unzip"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rf src/com/swabunga/test || die
}

src_install() {
	java-pkg-simple_src_install

	use doc && dodoc README.txt
	use examples && java-pkg_doexamples --subdir \
		com/swabunga/spell/examples \
		src/com/swabunga/spell/examples
}
