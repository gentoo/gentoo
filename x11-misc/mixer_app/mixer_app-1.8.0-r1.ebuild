# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=Mixer.app-${PV}

DESCRIPTION="mixer_app has volume controllers that can be configured to handle sound sources"
HOMEPAGE="http://www.fukt.bsnet.se/~per/mixer/"
SRC_URI="http://www.fukt.bsnet.se/~per/mixer/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	virtual/os-headers
	x11-base/xorg-proto"

DOCS=( ChangeLog README )

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_compile() {
	tc-export CXX
	emake
}
