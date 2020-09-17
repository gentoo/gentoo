# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXTerminal"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="gtk3"

DEPEND="dev-libs/glib:2
	!gtk3? (
		x11-libs/gtk+:2
		x11-libs/vte:0 )
	gtk3? (
		x11-libs/gtk+:3
		x11-libs/vte:2.91 )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-man $(use_enable gtk3)
}
