# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Lightweight C library of portability wrappers and data structures"
HOMEPAGE="https://gitlab.com/drobilla/zix"
if [[ ${PV} == *_p* ]] ; then
	COMMIT=a970ac9c1fa1341b83f2b1a4a1740590ec2cbfe7
	SRC_URI="https://gitlab.com/drobilla/zix/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2 -> ${P}-${COMMIT:0:8}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT}"
else
	SRC_URI="https://download.drobilla.net/${P}.tar.xz"
fi

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
