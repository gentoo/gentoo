# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

MY_P="${PN}-version-${PV}"
DESCRIPTION="Strict, simple, lightweight RFC3339 functions"
HOMEPAGE="
	https://pypi.org/project/strict-rfc3339/
	https://github.com/danielrichman/strict-rfc3339
"
SRC_URI="
	https://github.com/danielrichman/${PN}/archive/version-${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest
