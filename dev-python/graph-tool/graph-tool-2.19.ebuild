# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit check-reqs python-r1 toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/count0/graph-tool.git"
	inherit autotools git-r3
else
	SRC_URI="https://downloads.skewed.de/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An efficient python module for manipulation and statistical analysis of graphs"
HOMEPAGE="https://graph-tool.skewed.de/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+cairo openmp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-libs/expat
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=sci-mathematics/cgal-4.9
	cairo? (
		dev-cpp/cairomm
		dev-python/pycairo[${PYTHON_USEDEP}]
	)
	dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-cpp/sparsehash
	virtual/pkgconfig"

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
	local threads
	has_version 'dev-libs/boost[threads]' && threads="-mt"

	configure() {
		econf \
			--disable-static \
			--disable-optimization \
			$(use_enable openmp) \
			$(use_enable cairo) \
			--with-boost-python="${EPYTHON: -3}${threads}"
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
