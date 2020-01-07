# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
inherit distutils-r1

DESCRIPTION="SHA-3 (Keccak) for Python 2.7 - 3.5"
HOMEPAGE="https://github.com/tiran/pysha3 https://pypi.org/project/pysha3/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0 PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Remove meaningless AttributeError checks. They don't really test
	# the implementation but Python implementation behavior, and they
	# fail with PyPy. Oh yes, and this doesn't affect correctly written
	# programs.
	sed -i -e '/AttributeError/d' tests.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
