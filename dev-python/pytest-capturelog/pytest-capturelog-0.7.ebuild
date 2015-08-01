# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytest-capturelog/pytest-capturelog-0.7.ebuild,v 1.2 2015/08/01 10:31:04 patrick Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="py.test plugin to capture log messages"
HOMEPAGE="http://bitbucket.org/memedough/pytest-capturelog/overview"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/py[${PYTHON_USEDEP}]"
