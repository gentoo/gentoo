# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'

inherit meson python-any-r1

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="http://drobilla.net/software/suil/"
SRC_URI="http://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc gtk qt5"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
"
CDEPEND="
	media-libs/lv2
	gtk? ( x11-libs/gtk+:2 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)"
RDEPEND="${CDEPEND}"
DEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s%install_dir: docdir / 'suil-0',%install_dir: docdir / '${PF}',%g" doc/c/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc docs)
		$(meson_feature gtk gtk3)
		$(meson_feature qt5)
	)

	meson_src_configure
}
