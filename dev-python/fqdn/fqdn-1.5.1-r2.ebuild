# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="RFC-compliant FQDN validation and manipulation for Python"
HOMEPAGE="
	https://github.com/ypcrts/fqdn/
	https://pypi.org/project/fqdn/
"
SRC_URI="
	https://github.com/ypcrts/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
distutils_enable_sphinx docs
