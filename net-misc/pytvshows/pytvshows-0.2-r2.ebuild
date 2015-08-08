# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="downloads torrents for TV shows from RSS feeds provided by ezrss.it"
HOMEPAGE="http://sourceforge.net/projects/pytvshows/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-ezrss.it.patch"
	"${FILESDIR}/${P}-feedurl.patch"
	"${FILESDIR}/${P}-improved-re.patch" )

pkg_setup() {
	python-single-r1_pkg_setup
}
