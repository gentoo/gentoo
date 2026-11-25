# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="tzinfo object for the local timezone"
HOMEPAGE="
	https://github.com/regebro/tzlocal/
	https://pypi.org/project/tzlocal/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest
