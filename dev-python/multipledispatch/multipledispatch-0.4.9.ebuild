# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="RESTful HTTP Content Negotiation for Flask, Bottle, web.py and webapp2"
HOMEPAGE="https://multiple-dispatch.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE=""
RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
