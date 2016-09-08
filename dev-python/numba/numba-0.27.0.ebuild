# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="http://numba.pydata.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/llvmlite-0.10[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python{2_7,3_3})
	virtual/python-funcsigs[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( virtual/python-singledispatch[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Delete intersphinx & entry to set sphinxjp.themecore, which is absent from portage, from conf.py
PATCHES=( "${FILESDIR}"/${PN}-0.19.2-docbuild.patch )

python_prepare_all() {
	# Re-set them of doc build to one provided by sphinx
	if has_version ">=dev-python/sphinx-1.3.1"; then
		sed -e 's:basicstrap:classic:' -i docs/source/conf.py || die
	else
		sed -e 's:basicstrap:default:' -i docs/source/conf.py || die
	fi
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs/ html
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${PYTHON} -c "import numba; numba.test()" || die
}

python_install_all() {
	# doc needs obsolete sphinxjp package
#	use doc && dodoc docs/Numba.pdf
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
