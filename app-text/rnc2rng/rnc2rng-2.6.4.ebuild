# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="RELAX NG Compact to regular syntax conversion library"
HOMEPAGE="https://github.com/djc/rnc2rng"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/rply[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

python_test() {
	"${PYTHON}" test.py
}
