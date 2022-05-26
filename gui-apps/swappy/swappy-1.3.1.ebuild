# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
"
RDEPEND="${DEPEND}
	media-fonts/fontawesome[otf]
"
BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
"

src_prepare() {
	default

	# See https://github.com/jtheoof/swappy/pull/99
	sed -i -e 's/Utility;Graphics;Annotation;/Utility;Graphics;/'  src/po/swappy.desktop.in || die "Sed failed!"
}

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
