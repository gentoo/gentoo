# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Lightweight panel/taskbar for Linux"
HOMEPAGE="https://gitlab.com/o9000/tint2"
SRC_URI="https://gitlab.com/o9000/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86"
IUSE="battery startup-notification svg tint2conf"

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
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_BATTERY="$(usex battery)"
		-DENABLE_TINT2CONF="$(usex tint2conf)"
		-DENABLE_SN="$(usex startup-notification)"
		-DENABLE_RSVG="$(usex svg)"
	)
	cmake_src_configure
}
