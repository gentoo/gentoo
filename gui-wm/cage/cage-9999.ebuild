# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="wayland kiosk"
HOMEPAGE="https://www.hjdskes.nl/projects/cage/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Hjdskes/cage"
else
	SRC_URI="https://github.com/Hjdskes/cage/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+X +man"

DEPEND="
	>=gui-libs/wlroots-0.11.0[X?]
	x11-libs/pixman
	x11-libs/libxkbcommon[X?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		$(meson_use X xwayland)
		$(meson_feature man man-pages)
	)
	meson_src_configure
}
