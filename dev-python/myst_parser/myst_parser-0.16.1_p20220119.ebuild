# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

# one time use of snapshot for some changes from master
# next bump, just use github tarballs for tests
COMMIT="7654462dc8521c0090478efa4dcfba6227e97a84"

DESCRIPTION="Extended commonmark compliant parser, with bridges to sphinx"
HOMEPAGE="https://pypi.org/project/myst-parser/ https://github.com/executablebooks/MyST-Parser"
SRC_URI="
	https://github.com/executablebooks/MyST-Parser/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/MyST-Parser-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

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

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Unimportant tests needing a new dep linkify
	tests/test_renderers/test_myst_config.py::test_cmdline
	tests/test_sphinx/test_sphinx_builds.py::test_extended_syntaxes
)
