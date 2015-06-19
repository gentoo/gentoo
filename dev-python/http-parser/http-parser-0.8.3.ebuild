# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/http-parser/http-parser-0.8.3.ebuild,v 1.13 2015/05/31 11:05:50 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="HTTP request/response parser for python in C"
HOMEPAGE="http://github.com/benoitc/http-parser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~s390 x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

cython_dep() {
	local flag
	for flag in $(python_gen_useflags 'python*'); do
		DEPEND+=" ${flag}? ( dev-python/cython[${flag}(-)] )"
	done
}
cython_dep

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
