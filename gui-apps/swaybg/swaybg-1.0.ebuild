# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A wallpaper utility for Wayland"
HOMEPAGE="https://github.com/swaywm/swaybg"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	SRC_URI="https://github.com/swaywm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man"

DEPEND="
	dev-libs/wayland
"
RDEPEND="
	${DEPEND}
	!<gui-wm/sway-1.1_alpha1
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.14
	x11-libs/gdk-pixbuf
	x11-libs/cairo
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		"-Dwerror=false"
	)

	meson_src_configure
}
