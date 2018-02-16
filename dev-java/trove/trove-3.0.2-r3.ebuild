# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="GNU Trove: High performance collections for Java"
SRC_URI="mirror://sourceforge/trove4j/${P}.tar.gz"
HOMEPAGE="http://trove4j.sourceforge.net"
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

SLOT="0"
LICENSE="LGPL-2.1"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PV}"

RESTRICT="test"

src_unpack() {
	unpack ${A}
	mv "${PV}/${P}-src.jar" . || die
	rm -rf "${PV}" || die
	mkdir "${P}" || die
	unzip -d "${P}" -qq "${P}-src.jar" || die
	export S="${WORKDIR}/${P}"
}

src_prepare() {
	default
	find . -type f ! -name "*.java" -exec rm -v {} \; || die
}
