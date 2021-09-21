# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

MY_P=${P/-/_}
DESCRIPTION="Type Hint extensions from Python 3.8 backported"
HOMEPAGE="
	https://pypi.org/project/typing-extensions/
	https://github.com/python/typing/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_P%-*}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

python_test() {
	cd "${S}"/src_py3 || die
	"${EPYTHON}" test_typing_extensions.py -v || die "tests failed under ${EPYTHON}"
}
