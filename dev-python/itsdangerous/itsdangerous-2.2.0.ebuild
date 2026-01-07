# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Various helpers to pass trusted data to untrusted environments and back"
HOMEPAGE="
	https://palletsprojects.com/p/itsdangerous/
	https://github.com/pallets/itsdangerous/
	https://pypi.org/project/itsdangerous/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
