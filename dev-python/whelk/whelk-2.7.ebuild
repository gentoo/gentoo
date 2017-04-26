# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Pretending python is a shell"
HOMEPAGE="https://pypi.python.org/pypi/whelk"
SRC_URI="https://github.com/seveas/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests fail with ${EPYTHON}"
}
