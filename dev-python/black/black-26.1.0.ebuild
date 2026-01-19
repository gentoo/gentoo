# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/psf/black
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="
	https://black.readthedocs.io/en/stable/
	https://github.com/psf/black/
	https://pypi.org/project/black/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/mypy-extensions-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-22.0[${PYTHON_USEDEP}]
	>=dev-python/pathspec-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2[${PYTHON_USEDEP}]
	>=dev-python/pytokens-0.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/aiohttp-3.10[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# https://github.com/psf/black/issues/4582
				'tests/test_format.py::test_simple_format[backslash_before_indent]'
				'tests/test_format.py::test_simple_format[form_feeds]'
			)
			;;
	esac

	epytest
}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" \
		"dev-python/aiohttp dev-python/aiohttp-cors"
}
