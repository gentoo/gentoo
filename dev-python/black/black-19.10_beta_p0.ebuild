# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_p/}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://github.com/psf/black"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/typed-ast[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/dataclasses[${PYTHON_USEDEP}]' 'python3_6' )
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/mypy_extensions[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${MY_PV}"

distutils_enable_tests pytest
