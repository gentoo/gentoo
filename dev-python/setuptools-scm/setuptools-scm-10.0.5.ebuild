# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pypa/setuptools-scm
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="
	https://github.com/pypa/setuptools-scm/
	https://pypi.org/project/setuptools-scm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

# there's an optional dep on rich for cute logs
RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-64[${PYTHON_USEDEP}]
	>=dev-python/vcs-versioning-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/vcs-versioning-1.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		testing_scm/test_functions.py::test_dump_version_mypy
		testing_scm/test_integration.py::test_xmlsec_download_regression
		testing_scm/test_regressions.py::test_pip_download
	)

	if ! has_version "dev-python/pip[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			testing_scm/test_integration.py::test_editable_install_without_env_var
			testing_scm/test_integration.py::test_editable_install_version_file
		)
	fi

	epytest
}
