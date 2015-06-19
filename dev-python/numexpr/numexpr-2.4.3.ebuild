# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numexpr/numexpr-2.4.3.ebuild,v 1.1 2015/05/18 10:21:05 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
		local ext
		use amd64 && ext=_lp64
		cat <<- EOF > "${S}"/site.cfg
		[mkl]
		library_dirs = ${MKLROOT}/lib/em64t
		include_dirs = ${MKLROOT}/include
		mkl_libs = mkl_solver${ext}, mkl_intel${ext}, \
		mkl_intel_thread, mkl_core, iomp5
		EOF
	fi
	distutils-r1_python_prepare_all
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	# https://github.com/pydata/numexpr/issues/177
	# there are 2 known test failures under py3 only
	pushd "${BUILD_DIR}"/lib > /dev/null
	"${PYTHON}" -c "import numexpr; numexpr.test()" || die
	pushd > /dev/null
}
