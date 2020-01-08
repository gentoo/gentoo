# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.22"

inherit gnome2 meson vala

DESCRIPTION="Simple animated Gif screen recorder"
HOMEPAGE="https://github.com/phw/peek"
SRC_URI="https://github.com/phw/peek/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keybinder test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/glib-2.38:2
	media-video/ffmpeg[X,encode,vpx,xcb]
	virtual/imagemagick-tools
	>=x11-libs/gtk+-3.20:3
	keybinder? ( dev-libs/keybinder:3 )"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/txt2man
	>=sys-devel/gettext-0.19
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-meson.patch )

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature keybinder enable-keybinder)
		$(meson_use test build-tests)
	)

	meson_src_configure
}
