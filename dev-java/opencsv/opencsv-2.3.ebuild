# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A very simple csv (comma-separated values) parser library for Java"
HOMEPAGE="http://opencsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src-with-libs.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

IUSE=""

RESTRICT="test"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rf test || die
}
