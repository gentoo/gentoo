# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit check-reqs python-r1 toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.skewed.de/count0/graph-tool.git"
	inherit autotools git-r3
else
	SRC_URI="https://downloads.skewed.de/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

DESCRIPTION="An efficient python module for manipulation and statistical analysis of graphs"
HOMEPAGE="https://graph-tool.skewed.de/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+cairo openmp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/boost-1.70:=[context,python,${PYTHON_USEDEP}]
	dev-libs/expat:=
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-mathematics/cgal:=
	cairo? (
		dev-cpp/cairomm
		dev-python/pycairo[${PYTHON_USEDEP}]
	)
	dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-cpp/sparsehash"
BDEPEND="virtual/pkgconfig"

# bug 453544
CHECKREQS_DISK_BUILD="6G"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	check-reqs_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
	python_copy_sources
}

src_configure() {
	configure() {
		econf \
			--disable-static \
			$(use_enable openmp) \
			$(use_enable cairo) \
			--with-boost-python="boost_${EPYTHON/./}"
	}
	python_foreach_impl run_in_build_dir configure
}

src_compile() {
	# most machines don't have enough ram for parallel builds
	python_foreach_impl run_in_build_dir emake -j1
}

src_install() {
	python_foreach_impl run_in_build_dir default
	find "${D}" -name '*.la' -delete || die
}
