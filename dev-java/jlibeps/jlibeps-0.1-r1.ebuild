# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library to create EPS graphics from a Graphics2D"
HOMEPAGE="http://jlibeps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND="
	>=virtual/jre-1.4"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.4"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}
