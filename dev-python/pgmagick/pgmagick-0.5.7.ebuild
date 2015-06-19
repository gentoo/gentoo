# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pgmagick/pgmagick-0.5.7.ebuild,v 1.3 2015/04/08 08:05:14 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Yet another boost.python based wrapper for GraphicsMagick"
HOMEPAGE="https://pypi.python.org/pypi/pgmagick/ http://bitbucket.org/hhatto/pgmagick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-gfx/graphicsmagick[cxx]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
