# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="https://github.com/python/core-workflow/tree/master/blurb"

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
