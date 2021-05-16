# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Minimalist Window Manager for X"
HOMEPAGE="https://sithwm.darkside.no/"
SRC_URI="https://sithwm.darkside.no/sn/sithwm-${PV}.tgz"

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
