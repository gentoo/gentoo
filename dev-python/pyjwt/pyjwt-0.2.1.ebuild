# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyjwt/pyjwt-0.2.1.ebuild,v 1.7 2015/06/07 09:35:46 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="PyJWT"

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="http://github.com/progrium/pyjwt https://pypi.python.org/pypi/PyJWT/"
#SRC_URI="https://github.com/progrium/${P}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=" MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
S="${WORKDIR}"/${MY_PN}-${PV}
