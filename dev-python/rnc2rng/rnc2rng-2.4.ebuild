# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

DESCRIPTION="RELAX NG Compact to regular syntax conversion library"
HOMEPAGE="https://github.com/djc/rnc2rng"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/rply[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" test.py
}
