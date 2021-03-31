# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Capture C-level stdout/stderr in Python"
HOMEPAGE="
	https://github.com/minrk/wurlitzer/
	https://pypi.org/project/wurlitzer/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

src_prepare() {
	# things usually work better without typos
	sed -i -e 's:unitest:unittest:' test.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest test.py
}
