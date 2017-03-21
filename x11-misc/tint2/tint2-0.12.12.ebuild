# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils vcs-snapshot

DESCRIPTION="tint2 is a lightweight panel/taskbar for Linux."
HOMEPAGE="https://gitlab.com/o9000/tint2"
SRC_URI="https://gitlab.com/o9000/${PN}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="battery svg startup-notification tint2conf"

DEPEND="
	dev-libs/glib:2
	svg? ( gnome-base/librsvg:2 )
	>=media-libs/imlib2-1.4.2[X,png]
	x11-libs/cairo[X]
	x11-libs/pango
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

PATCHES=(
	"${FILESDIR}/${PV}-fix-compilation-without-svg.patch"
	"${FILESDIR}/${PV}-no-hardcode-update-icon-cache.patch"
	"${FILESDIR}/${PV}-relax-pango-includes.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_BATTERY="$(usex battery)"
		-DENABLE_TINT2CONF="$(usex tint2conf)"
		-DENABLE_SN="$(usex startup-notification)"
		-DENABLE_RSVG="$(usex svg)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
