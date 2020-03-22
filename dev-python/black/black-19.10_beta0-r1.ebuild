# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PV="${PV//_beta/b}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="
	https://github.com/psf/black
	https://pypi.org/project/black
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/appdirs-1.4[${PYTHON_USEDEP}]
	>=dev-python/attrs-18.1[${PYTHON_USEDEP}]
	>=dev-python/click-6.5[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.6[${PYTHON_USEDEP}]
	>=dev-python/regex-2019.11.1[${PYTHON_USEDEP}]
	>=dev-python/toml-0.9.4[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/dataclasses[${PYTHON_USEDEP}]' python3_6)
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-python/aiohttp-3.3.2[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${MY_PV}"

python_prepare_all() {
	# cannot get_version() for some reason so we set it here manually
	sed -i -e "s/get_version(root=CURRENT_DIR.parent)/${MY_PV::-2}/g" \
		-e '/for sp in "abcfr":/d' \
		-e '/version.split(sp)/d' \
		docs/conf.py || die

	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
# docs fail to build:: module 'black' has no attribute 'is_python36'
# 'release': return_codes_re.sub('', self.config.release),
distutils_enable_sphinx docs dev-python/recommonmark
