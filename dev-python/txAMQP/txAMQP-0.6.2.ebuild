# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Python library for communicating with AMQP peers using Twisted"
HOMEPAGE="https://launchpad.net/txamqp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86 ~x64-solaris"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/twisted-core"
