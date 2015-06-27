# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/moto/moto-0.4.3.ebuild,v 1.1 2015/06/27 05:37:27 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Mock library for boto"
HOMEPAGE="https://github.com/spulec/moto"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/boto-2.20.0[${PYTHON_USEDEP}]
	dev-python/dicttoxml[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	>=dev-python/httpretty-0.6.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]"
