# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A group of experimental matchers for Betamax"
HOMEPAGE="https://github.com/betamaxpy/betamax_matchers"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/betamax-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.4.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# No tests
RESTRICT=test
