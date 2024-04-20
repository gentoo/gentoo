# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="SMP system monitor dockapp"
HOMEPAGE="https://www.dockapps.net/wmsmpmon"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( ../Changelog )

S=${WORKDIR}/${P}/${PN}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default

	pushd "${WORKDIR}"/${P} || die
	eapply "${FILESDIR}"/${P}-fno-common.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}
