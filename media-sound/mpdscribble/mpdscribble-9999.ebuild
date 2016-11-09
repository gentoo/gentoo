# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="http://mpd.wikia.com/wiki/Client:Mpdscribble"
EGIT_REPO_URI="git://git.musicpd.org/master/mpdscribble.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+curl"

RDEPEND="dev-libs/glib
	media-libs/libmpdclient
	curl? ( net-misc/curl )
	!curl? ( net-libs/libsoup:2.4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--with-http-client=$(usex curl curl soup)
}

src_install() {
	default
	newinitd "${FILESDIR}/mpdscribble.rc" mpdscribble
	dodir /var/cache/mpdscribble
}
