# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson vala xdg

DESCRIPTION="Simple animated Gif screen recorder"
HOMEPAGE="https://github.com/phw/peek"
SRC_URI="https://github.com/phw/peek/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keybinder test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	media-video/ffmpeg[X,encode,x264,vpx,xcb(+)]
	virtual/imagemagick-tools
	>=x11-libs/gtk+-3.20:3
	keybinder? ( dev-libs/keybinder:3 )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/txt2man
	>=sys-devel/gettext-0.19
	virtual/pkgconfig
	$(vala_depend)"

PATCHES=( "${FILESDIR}"/${P}-meson.patch )

src_configure() {
	vala_setup

	local emesonargs=(
		$(meson_feature keybinder enable-keybinder)
		$(meson_use test build-tests)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
