# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/turbokid/turbokid-1.0.5-r1.ebuild,v 1.1 2015/01/11 00:14:40 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="TurboKid"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python template plugin that supports Kid templates"
HOMEPAGE="http://pypi.python.org/pypi/TurboKid"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=dev-python/kid-0.9.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
