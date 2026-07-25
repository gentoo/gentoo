# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="ISO 8601 date/time/duration parser and formatter"
HOMEPAGE="
	https://github.com/gweis/isodate/
	https://pypi.org/project/isodate/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
