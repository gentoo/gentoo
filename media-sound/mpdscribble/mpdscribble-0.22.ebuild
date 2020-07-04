# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="https://www.musicpd.org/clients/mpdscribble/"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+curl"

RDEPEND="dev-libs/glib:2
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
	keepdir /var/cache/mpdscribble
}
