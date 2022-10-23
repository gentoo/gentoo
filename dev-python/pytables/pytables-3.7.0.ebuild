# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="threads(+)"

MY_PN=tables
MY_P=${MY_PN}-${PV}
inherit distutils-r1

DESCRIPTION="Hierarchical datasets for Python"
HOMEPAGE="https://www.pytables.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:0=
	app-arch/lz4:0=
	>=app-arch/zstd-1.0.0:=
	>=dev-libs/c-blosc-1.11.1:0=
	dev-libs/lzo:2=
	>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
	>=sci-libs/hdf5-1.8.4:=
"
RDEPEND="${DEPEND}
	>=dev-python/numexpr-2.6.2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/cython-0.21[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		${RDEPEND}
	)
"

python_prepare_all() {
	export {BLOSC,BZIP2,LZO,HDF5}_DIR="${ESYSROOT}"/usr
	export PYTABLES_NO_EMBEDDED_LIBS=1
	export USE_PKGCONFIG=TRUE

	rm tables/*.c || die
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i setup.py || die
	rm -r c-blosc/{blosc,internal-complibs} || die
	sed -i -e '/_version/ s/\\s\*/\\s\+/' setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile -j1
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	"${EPYTHON}" tables/tests/test_all.py -v || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r contrib examples
		docompress -x /usr/share/doc/${PF}/{contrib,examples}
	fi
}
