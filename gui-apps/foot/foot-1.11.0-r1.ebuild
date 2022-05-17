# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+grapheme-clustering"

COMMON_DEPEND="
	dev-libs/wayland
	media-libs/fcft
	media-libs/fontconfig
	x11-libs/libxkbcommon
	x11-libs/pixman
	grapheme-clustering? (
		dev-libs/libutf8proc:=
		media-libs/fcft[harfbuzz]
	)
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/wayland-protocols
	dev-libs/tllist
"
RDEPEND="
	${COMMON_DEPEND}
	|| (
		>=sys-libs/ncurses-6.3[-minimal]
		~gui-apps/foot-terminfo-${PV}
	)
"
BDEPEND="
	dev-util/wayland-scanner
	app-text/scdoc
"

src_configure() {
	local emesonargs=(
		$(meson_feature grapheme-clustering)
		-Dthemes=true
		-Dime=true
		-Dterminfo=disabled
	)
	meson_src_configure
}

src_install() {
	local DOCS=( CHANGELOG.md README.md )
	meson_src_install

	rm -r "${ED}/usr/share/doc/${PN}" || die
}
