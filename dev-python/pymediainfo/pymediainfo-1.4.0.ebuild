# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A wrapper around the mediainfo command"
HOMEPAGE="https://github.com/paltman/pymediainfo https://pypi.python.org/pypi/pymediainfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
		media-video/mediainfo
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND} dev-python/setuptools[${PYTHON_USEDEP}]"
