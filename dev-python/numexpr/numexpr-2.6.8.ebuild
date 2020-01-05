# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="mkl"

RDEPEND="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	mkl? ( sci-libs/mkl )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# TODO: mkl can be used but it fails for me
	# only works with mkl in tree. newer mkl will use pkgconfig
	if use mkl; then
		use amd64 && local ext="_lp64"
		cat > site.cfg <<- _EOF_ || die
			[mkl]
			library_dirs = ${MKLROOT}/lib/em64t
			include_dirs = ${MKLROOT}/include
			mkl_libs = mkl_solver${ext}, mkl_intel${ext}, \
			mkl_intel_thread, mkl_core, iomp5
		_EOF_
	fi

	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS}"
		append-cflags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_test() {
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" \
		-c "import sys;import numexpr;sys.exit(0 if numexpr.test() else 1)" \
		|| die
	pushd >/dev/null || die
}
