# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://github.com/jaraco/keyring"
SRC_URI="https://github.com/jaraco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	dev-python/secretstorage[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	dev-python/jeepney[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/jaraco-packaging \
	dev-python/rst-linker

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
