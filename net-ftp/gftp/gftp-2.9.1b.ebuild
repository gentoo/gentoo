# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="a free multithreaded file transfer client"
SRC_URI="https://github.com/masneyb/gftp/releases/download/${PV}/${P}.tar.xz"
HOMEPAGE="https://github.com/masneyb/gftp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ppc64 ~riscv sparc x86"
IUSE="gtk ssl"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:0=
	sys-libs/readline:0
	gtk? ( x11-libs/gtk+:2 )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_enable gtk gtkport) \
		$(use_enable ssl)
}

src_install() {
	gnome2_src_install
	dodoc docs/USERS-GUIDE
}
