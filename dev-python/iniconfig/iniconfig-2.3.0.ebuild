# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pytest-dev/iniconfig
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Brain-dead simple config-ini parsing"
HOMEPAGE="
	https://github.com/pytest-dev/iniconfig/
	https://pypi.org/project/iniconfig/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
