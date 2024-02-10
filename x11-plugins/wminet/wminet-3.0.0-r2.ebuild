# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="dockapp for monitoring internet connections to and from your computer"
HOMEPAGE="http://www.improbability.net/#wminet"
SRC_URI="http://www.improbability.net/wmdock//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-list.patch
	"${FILESDIR}"/${P}-fno-common.patch
	)

DOCS=( AUTHORS ChangeLog NEWS README wminetrc )

src_compile() {
	tc-export CC
	emake LDFLAGS="${LDFLAGS}"
}
