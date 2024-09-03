# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

MATE_GTK_V="$(ver_cut 1-2)"

HOMEPAGE="https://mate-desktop.org"
DESCRIPTION="A set of MATE themes, with sets for users with limited or low vision"
SRC_URI="https://pub.mate-desktop.org/releases/themes/${MATE_GTK_V}/${P}.tar.xz"

LICENSE="CC-BY-SA-3.0 GPL-3+ LGPL-2.1+ LGPL-3"
SLOT="0/${MATE_GTK_V}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
RESTRICT="binchecks strip"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2:2
	>=x11-libs/gtk+-2:2
"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.8:*
	>=dev-build/autoconf-2.53
	>=x11-misc/icon-naming-utils-0.8.7:0
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	# Cleanup files from user's system as license is already accepted in package.licence
	# the default install phase chokes if they're not available to install.
	find "${ED}"/usr/share/themes -type f -name COPYING -delete || die
}
