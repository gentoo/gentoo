# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit locale-utils meson python-r1

DESCRIPTION="Unicode-aware text to PostScript converter"
HOMEPAGE="https://github.com/dov/paps"
SRC_URI="https://github.com/dov/paps/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	app-text/libpaper:=
	dev-libs/glib:2
	dev-libs/libfmt:=
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		app-text/poppler[utils]
		dev-libs/libxml2
	)
"

src_prepare() {
	default

	# even if it can be changed with --pango-outlang-path, fix the default value
	sed -e "/^pango_outlang_path =/s@/usr/local@${EPREFIX}/usr@" \
		-i scripts/src-to-paps || die
}

src_test() {
	# en_US.UTF-8 for inkscape_multipage
	# sv_SE.UTF-8 for test_format_from_dict (skipped otherwise)
	local -x LOCPATH LC_ALL
	elocale_gen --set LC_ALL en_US.UTF-8 sv_SE.UTF-8
	meson_src_test
}

src_install() {
	meson_src_install

	python_foreach_impl python_doscript scripts/src-to-paps
}
