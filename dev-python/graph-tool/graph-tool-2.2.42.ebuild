# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/graph-tool/graph-tool-2.2.42.ebuild,v 1.1 2015/04/27 09:20:56 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit check-reqs toolchain-funcs python-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/count0/graph-tool.git"
	inherit autotools git-r3
else
	SRC_URI="http://downloads.skewed.de/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An efficient python module for manipulation and statistical analysis of graphs"
HOMEPAGE="http://graph-tool.skewed.de/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+cairo openmp"

# Bug #536734; configure sets boostlib 1.53.0 but 1.54.0 is required 
CDEPEND="${PYTHON_DEPS}
	>=dev-libs/boost-1.54.0[python,${PYTHON_USEDEP}]
	dev-libs/expat
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=sci-mathematics/cgal-3.5
	cairo? (
		dev-cpp/cairomm
		dev-python/pycairo[${PYTHON_USEDEP}]
	)"
RDEPEND="${CDEPEND}
	dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-cpp/sparsehash
	virtual/pkgconfig"

# most machines don't have enough ram for parallel builds
MAKEOPTS="${MAKEOPTS} -j1"

# bug 453544
CHECKREQS_DISK_BUILD="6G"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
	check-reqs_pkg_pretend
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	>py-compile
	python_copy_sources
}

src_configure() {
	local threads
	has_version dev-libs/boost[threads] && threads="-mt"

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
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	prune_libtool_files --modules

	# remove unwanted extra docs
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
