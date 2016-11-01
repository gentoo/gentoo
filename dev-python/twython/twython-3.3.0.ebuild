# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="An easy (and up to date) way to access Twitter data with Python"
HOMEPAGE="https://github.com/ryanmcgrath/twython"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.4.0[${PYTHON_USEDEP}]"
