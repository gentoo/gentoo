# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs autotools

DESCRIPTION="dockapp for monitoring internet connections to and from your computer"
HOMEPAGE="https://www.improbability.net/#wminet"
SRC_URI="https://www.improbability.net/wmdock//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-list.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-missing-include.patch
	)

DOCS=( AUTHORS ChangeLog NEWS README wminetrc )

src_prepare() {
	default

	# bug https://bugs.gentoo.org/875137
	# bug https://bugs.gentoo.org/908912
	eautoreconf
}

src_compile() {
	tc-export CC
	emake LDFLAGS="${LDFLAGS}"
}
