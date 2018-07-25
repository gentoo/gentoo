# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2-utils xdg-utils

DESCRIPTION="A fast, small and powerful file manager and graphical shell"
HOMEPAGE="http://xffm.org/"
SRC_URI="mirror://sourceforge/xffm/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/librfm-5.3.16.3"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog TODO )

src_prepare() {
	pushd apps/rodent-pkg >/dev/null || die
	sed -i -e "/^install-data-hook/d" \
		-e "/rm -f/d" Build/Makefile.am || die
	eautoreconf
	popd >/dev/null || die
	default
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
