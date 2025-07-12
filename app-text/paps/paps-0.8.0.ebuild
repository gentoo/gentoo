# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit edo meson python-r1

DESCRIPTION="Unicode-aware text to PostScript converter"
HOMEPAGE="https://github.com/dov/paps"
SRC_URI="https://github.com/dov/paps/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/glib:2
	dev-libs/libfmt:=
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# patches merged in upstream, to be removed for the next version.
	"${FILESDIR}"/${P}-fix_glib.patch
	"${FILESDIR}"/${P}-fix_unused_results.patch
	"${FILESDIR}"/${P}-fix_fmt11.2.patch
)

src_prepare() {
	default

	# even if it can be changed with --pango-outlang-path, fix the default value
	sed -e "/^pango_outlang_path =/s/\/usr\/local/${EPREFIX}\/usr/" \
		-i scripts/src-to-paps || die
}

src_test() {
	edo "${BUILD_DIR}"/src/paps examples/small-hello.utf8 -o "${T}"/test-out.ps
}

src_install() {
	meson_src_install

	python_foreach_impl python_doscript scripts/src-to-paps
}
