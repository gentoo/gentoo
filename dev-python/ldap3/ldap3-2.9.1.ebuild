# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1

DESCRIPTION="A strictly RFC 4511 conforming LDAP V3 pure Python client"
HOMEPAGE="
	https://github.com/cannatag/ldap3/
	https://pypi.org/project/ldap3/
"
SRC_URI="
	https://github.com/cannatag/ldap3/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"

# tests require a ldap server and extra configuration
RESTRICT="test"

RDEPEND="
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
"
