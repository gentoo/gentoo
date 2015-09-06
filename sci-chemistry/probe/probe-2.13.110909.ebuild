# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Evaluates atomic packing within or between molecules"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/probe.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/probe/${MY_P}.src.zip"

SLOT="0"
LICENSE="richardson"
KEYWORDS="amd64 ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_P}.src

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	tc-export CC
}

src_install() {
	dobin "${S}"/probe
	dodoc "${S}"/README*
}
