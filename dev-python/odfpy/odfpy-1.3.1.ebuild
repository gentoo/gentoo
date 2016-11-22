# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Classifier: Programming Language :: Python :: 2 :: Only
# py3 fails one test, pypy anpother.
# Notes on page of home repo reports support of python3.
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Python API and tools to manipulate OpenDocument files"
HOMEPAGE="https://joinup.ec.europa.eu/software/odfpy/home https://pypi.python.org/pypi/odfpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

# Tarball missing required folder to build docs in html.

python_test() {
	# Known single fail under python3 suspected to be caused in python3 itself
	# https://github.com/eea/odfpy/issues/21

	local exit_status=0 test
	for test in tests/test*.py; do
		einfo "Running ${test} ..."
		"${PYTHON}" ${test}
		[[ $? -ne 0 ]] && exit_status=1
	done
	return ${exit_status}
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
