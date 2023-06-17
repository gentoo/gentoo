# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=github3.py-${PV}
DESCRIPTION="A wrapper for the GitHub API written in python"
HOMEPAGE="
	https://github.com/sigmavirus24/github3.py/
	https://pypi.org/project/github3.py/
"
SRC_URI="
	https://github.com/sigmavirus24/github3.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-vcs/git
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.3.0[${PYTHON_USEDEP}]
"
# via PyJWT[crypto]
RDEPEND+="
	>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/betamax-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/betamax-matchers-0.1.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' tox.ini || die
	distutils-r1_src_prepare
}
