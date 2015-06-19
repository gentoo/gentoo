# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ldap3/ldap3-0.9.8.2.ebuild,v 1.1 2015/04/23 20:45:25 chutzpah Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="A strictly RFC 4511 conforming LDAP V3 pure Python client"
HOMEPAGE="https://github.com/cannatag/ldap3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/pyasn1-0.1.7"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
