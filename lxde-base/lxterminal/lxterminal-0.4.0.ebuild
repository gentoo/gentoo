# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXTerminal"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	x11-libs/vte:2.91
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	econf --enable-man --enable-gtk3
}
