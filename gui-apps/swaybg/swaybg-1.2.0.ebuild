# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A wallpaper utility for Wayland"
HOMEPAGE="https://github.com/swaywm/swaybg"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	SRC_URI="https://github.com/swaywm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="gdk-pixbuf +man"

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/cairo
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
"
RDEPEND="
	${DEPEND}
	!<gui-wm/sway-1.1_alpha1
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		-Dgdk-pixbuf=$(usex gdk-pixbuf enabled disabled)
	)

	meson_src_configure
}
