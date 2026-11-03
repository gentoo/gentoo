# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pyscaffold/configupdater
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Parser like ConfigParser but for updating configuration files"
HOMEPAGE="
	https://github.com/pyscaffold/configupdater/
	https://pypi.org/project/ConfigUpdater/
"

LICENSE="MIT PSF-2 PYTHON"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
