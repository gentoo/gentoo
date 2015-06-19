# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numexpr/numexpr-2.4.1.ebuild,v 1.1 2015/04/20 04:21:19 idella4 Exp $

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
	dev-python/numpy[${PYTHON_USEDEP}]
	mkl? ( sci-libs/mkl )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( ANNOUNCE.rst AUTHORS.txt README.rst RELEASE_NOTES.rst )

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

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	"${PYTHON}" -c "import numexpr; numexpr.test()" || die
}
