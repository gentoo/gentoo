# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'

inherit meson-multilib python-single-r1

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="https://drobilla.net/software/lilv.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="doc python test tools"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/serd[${MULTILIB_USEDEP}]
	dev-libs/sord[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	media-libs/lv2[${MULTILIB_USEDEP}]
	media-libs/sratom[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s%install_dir: docdir / 'lilv-0',%install_dir: docdir / '${PF}',%g" doc/c/meson.build || die
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
