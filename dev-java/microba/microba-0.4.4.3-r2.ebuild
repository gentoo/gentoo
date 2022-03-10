# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Swing components for date operations and palettes"
HOMEPAGE="https://github.com/tdbear/microba"
SRC_URI="https://github.com/tdbear/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="dev-java/jgraph:0"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

DOCS=(
	change.log.txt
	readme.txt
	README.md
)

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar ${JAVA_SRC_DIR}
}

src_install() {
	default
	java-pkg-simple_src_install
}
