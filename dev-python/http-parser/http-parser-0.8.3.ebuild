# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="HTTP request/response parser for python in C"
HOMEPAGE="https://github.com/benoitc/http-parser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~s390 ~sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/cython[${PYTHON_USEDEP}]' 'python*')"

python_compile() {
	if [[ ${EPYTHON} != python3* ]]; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_install_all() {
	local DOCS=( README.rst )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
