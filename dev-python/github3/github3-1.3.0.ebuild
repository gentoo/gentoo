# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A wrapper for the GitHub API written in python"
HOMEPAGE="https://github3py.readthedocs.io/en/master/"
SRC_URI="https://github.com/sigmavirus24/${PN}.py/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.py-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-vcs/git
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/jwcrypto-0.5.0[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/betamax-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/betamax-matchers-0.1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
