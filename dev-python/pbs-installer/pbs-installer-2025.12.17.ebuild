# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/frostming/pbs-installer
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Installer for Python Build Standalone"
HOMEPAGE="
	https://pypi.org/project/pbs-installer/
	https://github.com/frostming/pbs-installer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

# httpx is needed to download builds
# zstandard is needed to install them
RDEPEND="
	<dev-python/httpx-1[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.21.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-import-check )
distutils_enable_tests import-check
