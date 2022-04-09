# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="https://github.com/python/core-workflow/tree/master/blurb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_test() {
	# Tests expect to be run from github repo, in which code is inside dir
	ln -s . blurb || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" -m blurb test || die "Tests failed with ${EPYTHON}"
}
