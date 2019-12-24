# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Minimalist Window Manager for X"
HOMEPAGE="http://sithwm.darkside.no/"
SRC_URI="http://sithwm.darkside.no/sn/sithwm-1.2.3.tgz"

LICENSE="GPL-2+ MIT 9wm"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-install.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}
