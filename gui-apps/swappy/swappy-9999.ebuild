# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg optfeature

DESCRIPTION="A Wayland native snapshot and editor tool, inspired by Snappy on macOS"
HOMEPAGE="https://github.com/jtheoof/swappy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jtheoof/swappy"
else
	SRC_URI="https://github.com/jtheoof/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

COMMON_DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
"
RDEPEND="${COMMON_DEPEND}
	media-fonts/fontawesome[otf]
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/scdoc
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "persisting clipboard after closing" gui-apps/wl-clipboard
}
