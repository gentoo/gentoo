# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pycnb/pycnb-0.0.4.ebuild,v 1.3 2015/04/08 18:04:50 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Access cnb.cz daily rates with the comfort of your command line"
HOMEPAGE="https://github.com/yaccz/pycnb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/cement[${PYTHON_USEDEP}]
	dev-python/twisted-web
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
