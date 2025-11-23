# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg-utils

DESCRIPTION="A background browser and setter for X"
HOMEPAGE="https://github.com/l3ib/nitrogen"
SRC_URI="https://github.com/l3ib/nitrogen/releases/download/${PV}/${P}.tar.gz"
KEYWORDS="amd64 ~ppc x86"

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

PATCHES=(
	"${FILESDIR}/${P}-fix-appdata-install-location.patch" # https://github.com/l3ib/nitrogen/pull/156
)

src_prepare() {
	default
	mv data/nitrogen.{appdata,metainfo}.xml || die

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
