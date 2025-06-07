# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_USE_PEP517="hatchling"

inherit distutils-r1

DESCRIPTION="Scan dependencies for known vulnerabilities and licenses."
HOMEPAGE="https://safetycli.com"
SRC_URI="https://github.com/pyupio/safety/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-0001-feat-replace-nltk-with-pyspellchecker.patch"
	"${FILESDIR}/${PN}-${PV}-0002-chore-add-tests-for-typosquatting.patch"
	"${FILESDIR}/${PN}-${PV}-0003-opt-in-telemetry.patch"
)

RDEPEND="
	>=dev-python/authlib-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.2.0[${PYTHON_USEDEP}]
	>=dev-python/dparse-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.16.1[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/marshmallow-3.15.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-6.1.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.10.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	>=dev-python/safety-schemas-0.0.14[${PYTHON_USEDEP}]
	>=dev-python/setuptools-65.5.1[${PYTHON_USEDEP}]
	>=dev-python/typer-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.7.1[${PYTHON_USEDEP}]
	>=dev-python/pyspellchecker-0.8.2[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_cli.py::TestSafetyCLI::test_announcements_if_is_not_tty \
	tests/test_safety.py::TestSafety::test_check_live \
	tests/test_safety.py::TestSafety::test_check_live_cached \
	tests/test_safety.py::TestSafety::test_get_packages_licenses_without_api_key
)
