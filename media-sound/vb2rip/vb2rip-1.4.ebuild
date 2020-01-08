# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV//./}

DESCRIPTION="Konami VB2 sound format ripping utility"
HOMEPAGE="http://www.neillcorlett.com/vb2rip"
SRC_URI="http://www.neillcorlett.com/vb2rip/${PN}${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="app-arch/unzip"

S=${WORKDIR}/src

PATCHES=( "${FILESDIR}"/${PN}-1.4-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin vb2rip
	dodoc "${WORKDIR}"/{games.txt,vb2rip.txt}
}
