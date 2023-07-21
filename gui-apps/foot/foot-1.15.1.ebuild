# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg systemd

DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+grapheme-clustering test"
RESTRICT="!test? ( test )"

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
	>=dev-libs/tllist-1.1.0
	dev-libs/wayland-protocols
"
RDEPEND="
	${COMMON_DEPEND}
	|| (
		>=sys-libs/ncurses-6.3[-minimal]
		~gui-apps/foot-terminfo-${PV}
	)
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
"

src_prepare() {
	default
	# disable the systemd dep, we install the unit file manually
	sed -i "s/systemd', required: false)$/', required: false)/" "${S}"/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature grapheme-clustering)
		$(meson_use test tests)
		-Dthemes=true
		-Dime=true
		-Dterminfo=disabled
	)
	meson_src_configure

	sed 's|@bindir@|/usr/bin|g' "${S}"/foot-server.service.in > foot-server.service || die
}

src_install() {
	local DOCS=( CHANGELOG.md README.md LICENSE )
	meson_src_install

	# foot unconditionally installs CHANGELOG.md, README.md and LICENSE.
	# we handle this via DOCS and dodoc instead.
	rm -r "${ED}/usr/share/doc/${PN}" || die
	systemd_douserunit foot-server.service "${S}"/foot-server.socket
}
