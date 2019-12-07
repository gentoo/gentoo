# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson ninja-utils

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="https://www.musicpd.org/clients/mpdscribble/"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-libs/boost
	dev-libs/libgcrypt
	media-libs/libmpdclient
	net-misc/curl"
DEPEND="${RDEPEND}"

src_install() {
	default
	meson_src_install
	rm -r "${D}/usr/share/doc/mpdscribble" || die
	dodoc AUTHORS NEWS README.rst
	doman doc/mpdscribble.1
	newinitd "${FILESDIR}/mpdscribble.rc" mpdscribble
}
