# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE='threads(+)'

inherit meson-multilib python-single-r1

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="https://drobilla.net/software/lilv.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE="doc python test tools"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
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
# Take care on bumps to check minimum versions!
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/serd-0.30.10[${MULTILIB_USEDEP}]
	>=dev-libs/sord-0.16.16[${MULTILIB_USEDEP}]
	>=dev-libs/zix-0.4.0[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	>=media-libs/lv2-1.18.2[${MULTILIB_USEDEP}]
	>=media-libs/sratom-0.6.10[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s/versioned_name/'${PF}'/g" doc/html/meson.build doc/singlehtml/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_feature python bindings_py)
		$(meson_feature test tests)
		$(meson_feature tools)
	)

	meson_src_configure
}

multilib_src_install() {
	meson_src_install
	python_optimize
}

multilib_src_install_all() {
	local DOCS=( AUTHORS NEWS README.md )
	einstalldocs

	newenvd - 60lv2 <<-EOF
		LV2_PATH=${EPREFIX}/usr/$(get_libdir)/lv2
	EOF
}
