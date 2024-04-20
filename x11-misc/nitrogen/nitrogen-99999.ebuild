# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic git-r3 xdg-utils

DESCRIPTION="A background browser and setter for X"
HOMEPAGE="https://github.com/l3ib/nitrogen"
EGIT_REPO_URI="https://github.com/l3ib/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls xinerama"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-cpp/gtkmm-2.10:2.4
	>=gnome-base/librsvg-2.20:2
	>=x11-libs/gtk+-2.10:2
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	default

	sed -i -e '/^UPDATE_DESKTOP/s#=.*#= :#g' data/Makefile.am || die

	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_enable nls) \
		$(use_enable xinerama)
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
