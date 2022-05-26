# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=MyST-Parser-${PV}
DESCRIPTION="Extended commonmark compliant parser, with bridges to sphinx"
HOMEPAGE="https://pypi.org/project/myst-parser/ https://github.com/executablebooks/MyST-Parser"
SRC_URI="
	https://github.com/executablebooks/MyST-Parser/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/docutils-0.18[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown-it-py[${PYTHON_USEDEP}]
	dev-python/mdit-py-plugins[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	<dev-python/sphinx-5[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		dev-python/pytest-param-files[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Unimportant tests needing a new dep linkify
	tests/test_renderers/test_myst_config.py::test_cmdline
	tests/test_sphinx/test_sphinx_builds.py::test_extended_syntaxes
)

distutils_enable_tests pytest
