# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Validating URI References per RFC 3986"
HOMEPAGE="
	https://rfc3986.rtfd.org/
	https://github.com/python-hyper/rfc3986/
	https://pypi.org/project/rfc3986/
	https://tools.ietf.org/html/rfc3986/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="idna"

RDEPEND="
	idna? (
		dev-python/idna[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/idna[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
