# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="XMMS2 AudioScrobbler client"
HOMEPAGE="http://code-monkey.de/pages/xmms2-scrobbler"
SRC_URI="ftp://ftp.code-monkey.de/pub/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-sound/xmms2
	net-misc/curl"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-libs.patch
	epatch "${FILESDIR}"/${P}-ld-order.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${EROOT}/usr" DESTDIR="${D}" install
	dodoc README AUTHORS
}

pkg_postinst() {
	einfo "xmms2-scrobbler will fail to start until you create a configfile"
	einfo ""
	einfo "mkdir -p ~/.config/xmms2/clients/xmms2-scrobbler/lastfm"
	einfo "echo 'user: foo' >> ~/.config/xmms2/clients/xmms2-scrobbler/lastfm/config"
	einfo "echo 'password: bar' >> ~/.config/xmms2/clients/xmms2-scrobbler/lastfm/config"
	einfo "echo 'handshake_url: http://post.audioscrobbler.com' >> ~/.config/xmms2/clients/xmms2-scrobbler/lastfm/config"
	einfo ""
	einfo "More info and configuration-options can be found in xmms2-scrobbler's README file"
}
