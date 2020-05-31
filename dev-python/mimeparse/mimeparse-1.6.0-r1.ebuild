# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )

inherit distutils-r1

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="https://github.com/dbtsai/python-mimeparse"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

python_test() {
	"${EPYTHON}" mimeparse_test.py -v || die "Tests fail with ${EPYTHON}"
}
