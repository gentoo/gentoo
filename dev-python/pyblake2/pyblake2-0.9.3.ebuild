# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )
inherit distutils-r1

DESCRIPTION="BLAKE2 hash function extension module"
HOMEPAGE="https://github.com/dchest/pyblake2 https://pypi.python.org/pypi/pyblake2"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_test() {
	"${EPYTHON}" test/test.py || die "Tests fail with ${EPYTHON}"
}
