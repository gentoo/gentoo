# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="
	https://github.com/jaraco/keyring/
	https://pypi.org/project/keyring/
"
SRC_URI="
	https://github.com/jaraco/keyring/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/secretstorage-3.2[${PYTHON_USEDEP}]
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	>=dev-python/jeepney-0.4.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-3.6[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

EPYTEST_DESELECT=(
	# this test fails if importlib-metadata returns more than one
	# entry, i.e. when keyring is installed already
	tests/test_packaging.py::test_entry_point
)

EPYTEST_IGNORE=(
	# apparently does not unlock the keyring properly
	tests/backends/test_libsecret.py
	# hangs
	tests/backends/test_kwallet.py
)
