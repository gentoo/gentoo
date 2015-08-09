# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"

inherit eutils distutils

DESCRIPTION="Seekwatcher generates graphs from blktrace runs to help visualize IO patterns and performance"
HOMEPAGE="http://oss.oracle.com/~mason/seekwatcher/"
#SRC_URI="http://oss.oracle.com/~mason/seekwatcher/${P}.tar.bz2"
SRC_URI="http://dev.gentoo.org/~slyfox/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-python/pyrex"
RDEPEND="dev-python/matplotlib
		dev-python/numpy
		>=sys-block/btrace-0.0.20070730162628"

S=${WORKDIR}/${PN}-b392aeaf693b # hg snapshot

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-dash-fix.patch

	distutils_src_prepare
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "If you want to generate IO-movies from captured data, you must"
	elog "install at least one of the following packages:"
	elog "- media-video/mplayer with USE=encode"
	elog "- media-libs/libtheora with USE=examples"
}
