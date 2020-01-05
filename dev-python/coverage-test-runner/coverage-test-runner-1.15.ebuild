# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="fail Python program unit tests unless they test everything"
HOMEPAGE="https://liw.fi/coverage-test-runner/"
SRC_URI="http://git.liw.fi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-python/coverage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	emake check
}
