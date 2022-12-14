# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Lightweight panel/taskbar for Linux"
HOMEPAGE="https://gitlab.com/nick87720z/tint2"
SRC_URI="https://gitlab.com/nick87720z/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"
IUSE="battery debug startup-notification sanitize svg tint2conf"

DEPEND="
	dev-libs/glib:2
	svg? ( gnome-base/librsvg:2 )
	>=media-libs/imlib2-1.4.2[X,png]
	x11-libs/cairo[X]
	x11-libs/pango
	tint2conf? ( x11-libs/gtk+:3 )
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.3
	x11-libs/libXrender
	startup-notification? ( x11-libs/startup-notification )
	debug? (
		sys-libs/libunwind
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_ASAN=$(usex sanitize)
		-DENABLE_BATTERY=$(usex battery)
		-DENABLE_TINT2CONF=$(usex tint2conf)
		-DENABLE_SN=$(usex startup-notification)
		-DENABLE_RSVG=$(usex svg)
		-DENABLE_BACKTRACE=$(usex debug)
		-DENABLE_BACKTRACE_ON_SIGNAL=$(usex debug)
		-DENABLE_TRACING=$(usex debug)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
