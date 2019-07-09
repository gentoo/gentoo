# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{5,6}} pypy )

inherit distutils-r1

DESCRIPTION="A debugger using ptrace (Linux, BSD and Darwin system call to trace processes)"
HOMEPAGE="https://github.com/haypo/python-ptrace/ https://pypi.org/project/python-ptrace/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

PATCHES=( "${FILESDIR}/0.8.1-python3.4.patch" )

python_test() {
	"${PYTHON}" runtests.py -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	# doc folder missing key files to effect a proper doc build
	use doc && local DOCS=( README doc/. )
	distutils-r1_python_install_all
}
