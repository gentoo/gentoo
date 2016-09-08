# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	sed -i 's:#!/usr/bin/env python:#!/usr/bin/env python2:' "${S}"/libgsmhr/fetch_sources.py
	eautoreconf
}

src_configure() {
	CXXFLAGS="$CXXFLAGS -I./include" CFLAGS="$CFLAGS -I./include" econf \
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
