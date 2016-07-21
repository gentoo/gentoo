# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DOCS=( ChangeLog README.rst  )

inherit distutils-r1

DESCRIPTION="IRCBot, telling people they should contact you on different nickname"
HOMEPAGE="https://github.com/yaccz/redirbot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-11.1.0
	dev-python/twisted-words
"
RDEPEND="${DEPEND}"
