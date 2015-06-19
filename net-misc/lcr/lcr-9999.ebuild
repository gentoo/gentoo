# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/lcr/lcr-9999.ebuild,v 1.3 2014/04/29 01:24:56 zx2c4 Exp $

EAPI=5

inherit git-2 autotools

DESCRIPTION="Linux Call Router"
HOMEPAGE="http://isdn.eversberg.eu/"
EGIT_REPO_URI="git://git.misdn.eu/lcr.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="asterisk +ssl +gsm-bs +gsm-ms ss5 +sip gsmhr misdn"

DEPEND="
	media-libs/opencore-amr
	asterisk? ( net-misc/asterisk )
	ssl? ( dev-libs/openssl )
	gsm-bs? ( net-wireless/openbsc )
	sip? ( net-libs/sofia-sip )
	gsm-ms? ( net-wireless/osmocom-bb )
"
	#mdisn? ( net-misc/misdn )
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_with asterisk) \
		$(use_with ssl) \
		$(use_with gsm-bs) \
		$(use_with gsm-ms) \
		$(use_with ss5) \
		$(use_with sip) \
		$(use_with misdn) \
		$(use_enable gsmhr)
}

src_compile() {
	emake -j1
}

pkg_postinst() {
	use gsmhr || return
	ewarn "You have enabled the gsmhr use flag, for the GSM half-rate"
	ewarn "codec. This is strongly discouraged, except for testing,"
	ewarn "because of extremely high CPU usage."
}
