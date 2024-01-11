# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Lightweight C library of portability wrappers and data structures"
#HOMEPAGE="https://drobilla.net/software/zix.html"
HOMEPAGE="https://gitlab.com/drobilla/zix"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-python/sphinx
		dev-python/sphinx-lv2-theme
		dev-python/sphinxygen
	)
"

src_prepare() {
	default

	# fix doc installation path
	sed -i "s/versioned_name/'${PF}'/g" doc/html/meson.build doc/singlehtml/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_feature test tests)
	)

	meson_src_configure
}

multilib_src_install_all() {
	local DOCS=( NEWS README.md )
	einstalldocs
}
