# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"
inherit cmake-utils gnome2-utils wxwidgets

DESCRIPTION="The official lobby client for SpringRTS community games"
HOMEPAGE="https://springlobby.info"
SRC_URI="https://www.springlobby.info/tarballs/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +libnotify +nls +sound"

RDEPEND="
	>=dev-libs/boost-1.35:=
	dev-libs/openssl:0=
	net-misc/curl
	sys-libs/zlib[minizip]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	libnotify? ( x11-libs/libnotify )
	sound? ( media-libs/alure
		media-libs/openal
	)
"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
		-DOPTION_NOTIFY=$(usex libnotify)
		-DOPTION_SOUND=$(usex sound)
		-DOPTION_TRANSLATION_SUPPORT=$(usex nls)
		-DAUX_VERSION="(Gentoo,${ARCH})"
		)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
