# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="https://drobilla.net/software/suil.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE="doc gtk gtk2 qt5 X"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
"
# This could be way refined, but it's quickly a rabbit hole

RDEPEND="
	media-libs/lv2
	gtk2? (
		x11-libs/gtk+:2
		dev-libs/glib:2
	)
	gtk? (
		x11-libs/gtk+:3
		dev-libs/glib:2
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	X? ( x11-libs/libX11 )
"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s%install_dir: docdir / 'suil-0',%install_dir: docdir / '${PF}',%g" doc/c/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc docs)
		$(meson_feature gtk2)
		$(meson_feature gtk gtk3)
		$(meson_feature qt5)
		$(meson_feature X x11)
	)

	meson_src_configure
}
