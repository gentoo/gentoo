# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A wallpaper utility for Wayland"
HOMEPAGE="https://github.com/swaywm/swaybg"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}.gh.tar.gz
		https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz.sig -> ${P}.gh.tar.gz.sig"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="gdk-pixbuf +man"

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.26
	x11-libs/cairo
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

if [[ ${PV} != 9999 ]]; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-emersion )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature gdk-pixbuf)
	)

	meson_src_configure
}
