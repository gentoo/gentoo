# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=AlsaMixer.app
MY_P=${MY_PN}-${PV}

DESCRIPTION="simple alsa mixer dockapp"
HOMEPAGE="https://www.dockapps.net/alsamixerapp"
SRC_URI="https://www.dockapps.net/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_compile() {
	tc-export CXX
	default
}
