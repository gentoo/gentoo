# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A program for visualizing NEC2 input and output data"
HOMEPAGE="https://www.pa3fwm.nl/software/xnecview/"
SRC_URI="https://www.pa3fwm.nl/software/xnecview/xnecview-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=media-libs/libpng-1.6
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-tc-variables.patch"
)

src_compile() {
	tc-export CC LD PKG_CONFIG
	emake
}

src_install() {
	dobin xnecview
	doman xnecview.1x
	dodoc README
	dodoc HISTORY
}
