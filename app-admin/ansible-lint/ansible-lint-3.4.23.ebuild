# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=${P/_/}

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/willthames/ansible-lint"
SRC_URI="https://github.com/willthames/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_P}"

CDEPEND="app-admin/ansible[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? (
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		)
		${CDEPEND}"
RDEPEND="${CDEPEND}"

python_test() {
	nosetests || die
}
