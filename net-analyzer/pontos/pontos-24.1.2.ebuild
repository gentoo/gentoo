# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Common utilities and tools maintained by Greenbone Networks"
HOMEPAGE="
	https://www.greenbone.net
	https://github.com/greenbone/pontos/
	https://greenbone.github.io/pontos/
"

SRC_URI="https://github.com/greenbone/pontos/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-python/colorful-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.5.11[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.3[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23[${PYTHON_USEDEP}]
	>=dev-python/rich-12.4.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/semver-2.13[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.0[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

EPYTEST_DESELECT=(
	tests/git/test_git.py::GitExtendedTestCase::test_git_error
	tests/version/commands/test_java.py::GetCurrentJavaVersionCommandTestCase::test_getting_version_without_version_config
	tests/version/commands/test_java.py::VerifyJavaVersionCommandTestCase::test_verify_version_does_not_match
)

distutils_enable_tests pytest
