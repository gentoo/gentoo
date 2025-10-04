# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Provides an API for querying the distutils metadata written in a PKG-INFO file"
HOMEPAGE="
	https://launchpad.net/pkginfo/
	https://pypi.org/project/pkginfo/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs

EPYTEST_DESELECT=(
	# fragile to Core Metadata version changing in setuptools
	# https://bugs.launchpad.net/pkginfo/+bug/2103804 (again)
	pkginfo/tests/test_installed.py::test_installed_ctor_w_dist_info
)
