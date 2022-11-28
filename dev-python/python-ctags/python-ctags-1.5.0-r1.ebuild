# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

MY_PN="${PN}3"
DESCRIPTION="Exuberant Ctags indexing python bindings"
HOMEPAGE="https://github.com/universal-ctags/python-ctags3"
# PyPI tarballs don't contain pyx files
SRC_URI="https://github.com/universal-ctags/python-ctags3/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-util/ctags:="
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# We currently need to let Cython regenerate this file to make Python 3.11
	# support work
	rm src/_readtags.c || die
	cython -3 src/_readtags.pyx || die
	distutils-r1_python_prepare_all
}

python_test() {
	# To prevent pytest from importing it and failing with:
	# ModuleNotFoundError: No module named 'ctags._readtags'
	rm -rf src/ctags || die
	epytest
}
