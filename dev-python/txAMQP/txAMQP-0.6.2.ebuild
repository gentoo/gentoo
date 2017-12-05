# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python library for communicating with AMQP peers using Twisted"
HOMEPAGE="https://github.com/txamqp/txamqp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86 ~x64-solaris"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/twisted-core[${PYTHON_USEDEP}]"
