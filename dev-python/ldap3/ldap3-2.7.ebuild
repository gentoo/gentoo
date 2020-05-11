# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A strictly RFC 4511 conforming LDAP V3 pure Python client"
HOMEPAGE="https://github.com/cannatag/ldap3 https://pypi.python.org/pypi/ldap3"
SRC_URI="https://github.com/cannatag/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
"
# tests require a ldap server and extra configuration
RESTRICT="test"

distutils_enable_tests nose
