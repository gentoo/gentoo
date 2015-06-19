# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vimpc/vimpc-0.09.0.ebuild,v 1.4 2014/08/10 21:12:50 slyfox Exp $

EAPI=4

DESCRIPTION="An ncurses based mpd client with vi like key bindings"
HOMEPAGE="http://vimpc.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/Release%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="boost taglib"

RDEPEND="dev-libs/libpcre
	media-libs/libmpdclient
	boost? ( dev-libs/boost )
	taglib? ( media-libs/taglib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

DOCS=( AUTHORS README.md doc/vimpcrc.example )

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable taglib) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default

	# vimpc will look for help.txt
	docompress -x /usr/share/doc/${PF}/help.txt
}
