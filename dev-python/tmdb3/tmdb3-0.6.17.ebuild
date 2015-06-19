# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tmdb3/tmdb3-0.6.17.ebuild,v 1.2 2015/04/08 08:05:16 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="TheMovieDB.org APIv3 interface"
HOMEPAGE="https://github.com/wagnerrp/pytmdb3 https://pypi.python.org/pypi/tmdb3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
