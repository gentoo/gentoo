# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Partial port of the C++ Standard Template Library"
SRC_URI="http://vigna.dsi.unimi.it/jal/${P}-src.tar.gz"
HOMEPAGE="http://vigna.dsi.unimi.it/jal/"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	source? ( app-arch/zip )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/buildxml.patch

	# we have to generate the sources first
	./instantiate -n byte bytes
	./instantiate -n short shorts
	./instantiate -n char chars
	./instantiate -n int ints
	./instantiate -n long longs
	./instantiate -n float floats
	./instantiate -n double doubles
	./instantiate Object objects
	./instantiate String strings
	mkdir -p src/jal
	mv bytes shorts chars ints longs floats doubles objects strings src/jal
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc "${S}"/src/jal
}
