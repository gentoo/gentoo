# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ACPI monitor for X11"
HOMEPAGE="http://bbacpi.sourceforge.net"
SRC_URI="mirror://sourceforge/bbacpi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="
	media-libs/imlib
	sys-power/acpi
	sys-power/acpid
	x11-libs/libX11
	x11-misc/xdialog"
RDEPEND="
	${DEPEND}
	media-fonts/font-adobe-100dpi"

PATCHES=(
	"${FILESDIR}"/${P}-noextraquals.diff
	"${FILESDIR}"/${P}-overflows.diff
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc data/README.bbacpi

	rm "${ED}"/usr/share/bbtools/README.bbacpi || die
}
