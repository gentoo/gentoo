# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="https://drobilla.net/software/suil.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc gtk gtk2 qt6 test X"
RESTRICT="!test? ( test )"

# This could be way refined, but it's quickly a rabbit hole
# Take care on bumps to check lv2 minimum version!
RDEPEND="
	media-libs/lv2
	gtk2? (
		>=x11-libs/gtk+-2.18.0:2
		dev-libs/glib:2
	)
	gtk? (
		>=x11-libs/gtk+-3.14.0:3
		dev-libs/glib:2
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-python/sphinx
		dev-python/sphinx-lv2-theme
		dev-python/sphinxygen
	)
	test? ( dev-libs/check )
"

DOCS=( AUTHORS NEWS README.md )

PATCHES=( "${FILESDIR}/${P}-fix-gtk2-option.patch" )

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s/versioned_name/'${PF}'/g" doc/html/meson.build doc/singlehtml/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dqt5=disabled
		$(meson_feature doc docs)
		$(meson_feature gtk2)
		$(meson_feature gtk gtk3)
		$(meson_feature qt6)
		$(meson_feature test tests)
		$(meson_feature X x11)
	)

	meson_src_configure
}
