# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A group of experimental matchers for Betamax"
HOMEPAGE="
	https://github.com/betamaxpy/betamax_matchers/
	https://pypi.org/project/betamax-matchers/
"
SRC_URI="
	https://github.com/betamaxpy/betamax_matchers/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${P/-/_}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/betamax-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.4.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
