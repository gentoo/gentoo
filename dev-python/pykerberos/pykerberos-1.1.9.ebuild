# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="A high-level Python wrapper for Kerberos/GSSAPI operations"
HOMEPAGE="http://trac.calendarserver.org/wiki/PyKerberos"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc64 x86"
IUSE=""

DEPEND="
	app-crypt/mit-krb5
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
