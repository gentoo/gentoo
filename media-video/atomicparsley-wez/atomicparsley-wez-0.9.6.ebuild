# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/atomicparsley-wez/atomicparsley-wez-0.9.6.ebuild,v 1.1 2014/03/11 19:07:43 ssuominen Exp $

EAPI=5

inherit autotools flag-o-matic

MY_PN=${PN/-wez}

DESCRIPTION="command line program for reading, parsing and setting iTunes-style metadata in MPEG4 files"
HOMEPAGE="http://github.com/wez/atomicparsley"
SRC_URI="http://bitbucket.org/wez/${MY_PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
	!media-video/atomicparsley"
DEPEND="${RDEPEND}"

DOCS="Changes.txt CREDITS"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf
}
