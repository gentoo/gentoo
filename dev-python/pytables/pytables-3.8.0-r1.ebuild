# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 prefix

MY_PN=tables
MY_P=${MY_PN}-${PV}

DESCRIPTION="Hierarchical datasets for Python"
HOMEPAGE="
	https://www.pytables.org/
	https://github.com/PyTables/PyTables/
	https://pypi.org/project/tables/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~riscv ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:0=
	app-arch/lz4:0=
	>=app-arch/zstd-1.0.0:=
	>=dev-libs/c-blosc-1.11.1:0=
	dev-libs/c-blosc2:=
	dev-libs/lzo:2=
	>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
	>=sci-libs/hdf5-1.8.4:=
"
RDEPEND="
	${DEPEND}
	>=dev-python/numexpr-2.6.2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-0.21[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		${RDEPEND}
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${P}-blosc2.patch
	)

	export PYTABLES_NO_EMBEDDED_LIBS=1
	export USE_PKGCONFIG=TRUE

	rm -r c-blosc/{blosc,internal-complibs} || die
	rm tables/libblosc2.so || die
	sed -i -e '/blosc2/d' requirements.txt || die
	hprefixify -w '/prefixes =/' setup.py
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
