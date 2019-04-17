# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit distutils-r1

MY_PV=${PV/_alpha/a}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="https://github.com/PyGithub/PyGithub/"
# Use github since pypi is missing test data
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pyjwt[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	# tests requiring network access
	sed -i -e 's:testDecodeJson:_&:' github/tests/Issue142.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
