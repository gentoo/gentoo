# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit check-reqs python-r1 toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.skewed.de/count0/graph-tool.git"
	inherit autotools git-r3
else
	SRC_URI="https://downloads.skewed.de/${PN}/${P}.tar.xz"
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
	dev-libs/boost:=[context,python,${PYTHON_USEDEP}]
	dev-libs/expat
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-mathematics/cgal:=
	dev-python/matplotlib[${PYTHON_USEDEP}]
	cairo? (
		dev-cpp/cairomm:0
		dev-python/pycairo[${PYTHON_USEDEP}]
		x11-libs/cairo[X]
	)"
DEPEND="${RDEPEND}
	dev-cpp/sparsehash"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/0001-Fix-compilation-with-boost-1.83-and-boost-1.76.patch # backport
)

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
	my_configure() {
		econf \
			--disable-static \
			$(use_enable openmp) \
			$(use_enable cairo) \
			--with-boost-python="boost_${EPYTHON/./}"
	}
	python_foreach_impl run_in_build_dir my_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir emake
}

src_install() {
	my_python_install() {
		default
		python_optimize
	}
	python_foreach_impl run_in_build_dir my_python_install

	find "${ED}" -name '*.la' -delete || die
}
