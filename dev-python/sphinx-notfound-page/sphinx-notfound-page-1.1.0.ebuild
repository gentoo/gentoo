# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Create a custom 404 page with absolute URLs hardcoded"
HOMEPAGE="
	https://sphinx-notfound-page.readthedocs.io/
	https://github.com/readthedocs/sphinx-notfound-page/
	https://pypi.org/project/sphinx-notfound-page/
"
SRC_URI="
	https://github.com/readthedocs/sphinx-notfound-page/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/sphinx-5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# calls sphinx-build directly, works around venv
	tests/test_urls.py::test_parallel_build

	# broken upstream (mismatch with new dev-python/sphinx?)
	# https://github.com/readthedocs/sphinx-notfound-page/issues/249
	tests/test_urls.py::test_default_settings
	tests/test_urls.py::test_urls_prefix_setting
	tests/test_urls.py::test_urls_prefix_setting_none
	tests/test_urls.py::test_custom_404_rst_source
	tests/test_urls.py::test_urls_for_dirhtml_builder
	tests/test_urls.py::test_toctree_urls_notfound_default
	tests/test_urls.py::test_toctree_links
	tests/test_urls.py::test_toctree_links_custom_settings
)
