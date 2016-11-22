# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils gnome2-utils

DESCRIPTION="tint2 is a lightweight panel/taskbar for Linux."
HOMEPAGE="https://gitlab.com/o9000/tint2"
SRC_URI="https://gitlab.com/o9000/${PN}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="battery examples svg startup-notification tint2conf"

DEPEND="
	dev-libs/glib:2
	svg? ( gnome-base/librsvg:2 )
	>=media-libs/imlib2-1.4.2[X,png]
	x11-libs/cairo
	x11-libs/pango[X]
	tint2conf? ( x11-libs/gtk+:2 )
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.3
	x11-libs/libXrender
	startup-notification? ( x11-libs/startup-notification )
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-v${PV}"

PATCHES=( "${FILESDIR}/${PV}-no-hardcode-update-icon-cache.patch" )

src_unpack() {
	default
	# Chop off the SHA1 gitlab's automated tarballs inject
	mv "${PN}-v${PV}-"* "${PN}-v${PV}"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable battery BATTERY)
		$(cmake-utils_use_enable examples EXAMPLES)
		$(cmake-utils_use_enable tint2conf TINT2CONF)
		$(cmake-utils_use_enable startup-notification SN)
		$(cmake-utils_use_enable svg RSVG)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
