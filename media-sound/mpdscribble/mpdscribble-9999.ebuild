# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="https://www.musicpd.org/clients/mpdscribble/"
EGIT_REPO_URI="https://github.com/MusicPlayerDaemon/mpdscribble.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+curl"

RDEPEND="dev-libs/glib:2
	media-libs/libmpdclient
	curl? ( net-misc/curl )
	!curl? ( net-libs/libsoup:2.4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-http-client=$(usex curl curl soup)
}

src_install() {
	default
	newinitd "${FILESDIR}/mpdscribble.rc" mpdscribble
	keepdir /var/cache/mpdscribble
}
