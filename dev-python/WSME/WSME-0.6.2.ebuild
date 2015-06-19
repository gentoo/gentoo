# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/WSME/WSME-0.6.2.ebuild,v 1.4 2014/11/28 09:58:30 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Simplify the writing of REST APIs, and extend them with additional protocols."
HOMEPAGE="http://pythonhosted.org//WSME"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.5.21[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ipaddr[${PYTHON_USEDEP}]' python{2_7,3_2})
"
