# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://github.com/psf/black https://pypi.org/project/black/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="async test"

RDEPEND="
	>=dev-python/attrs-18.1[${PYTHON_USEDEP}]
	>=dev-python/click-6.5[${PYTHON_USEDEP}]
	>=dev-python/toml-0.9.4[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4[${PYTHON_USEDEP}]
	async? (
		>=dev-python/aiohttp-3.4[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${PWD}:${PYTHONPATH}" ${PYTHON} -m pytest tests/ || die "Tests failed under ${EPYTHON}"
}
