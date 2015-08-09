# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_DEPEND="2"

inherit distutils eutils

DESCRIPTION="downloads torrents for TV shows from RSS feeds provided by ezrss.it"
HOMEPAGE="http://sourceforge.net/projects/pytvshows/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/feedparser"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-ezrss.it.patch"
	epatch "${FILESDIR}/${P}-feedurl.patch"
	epatch "${FILESDIR}/${P}-improved-re.patch"
	python_convert_shebangs -r 2 .
}
