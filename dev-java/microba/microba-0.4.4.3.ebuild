# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Swing components for date operations and palettes"
HOMEPAGE="https://github.com/tdbear/microba"
SRC_URI="https://github.com/tdbear/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/jgraph:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="jgraph"

JAVA_SRC_DIR="src"

src_install() {
	java-pkg-simple_src_install
	mv change.log.txt CHANGELOG || die
	mv readme.txt README || die
	dodoc {README,CHANGELOG,README.md}
}
