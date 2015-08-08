# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Seekwatcher generates graphs from blktrace runs to help visualize IO patterns and performance"
HOMEPAGE="http://oss.oracle.com/~mason/seekwatcher/"
SRC_URI="http://oss.oracle.com/~mason/seekwatcher/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/matplotlib-0.90.1
		>=sys-block/btrace-0.0.20070730162628"

src_install() {
	dobin seekwatcher
	dohtml README.html
}

pkg_postinst() {
	elog "If you want to generate IO-movies from captured data, you must"
	elog "install at least one of the following packages:"
	elog "- media-video/mplayer with USE=encode"
	elog "- media-libs/libtheora with USE=examples"
}
