# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="a client for MPD which submits your tracks to last.fm"
HOMEPAGE="https://cmende.github.com/scmpc/"
SRC_URI="https://dev.gentoo.org/~angelos/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	dev-libs/confuse
	media-libs/libmpdclient
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README.md scmpc.conf.example )

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-2.init ${PN}
	insinto /etc
	insopts -m600
	newins scmpc.conf.example scmpc.conf
}
