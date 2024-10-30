# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1 pypi

DESCRIPTION="Fork of the standard library cgi and cgitb modules (deprecated)"
HOMEPAGE="
	https://github.com/jackrosenthal/legacy-cgi/
	https://pypi.org/project/legacy-cgi/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
