# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="simple tuning app for DVB cards"
HOMEPAGE="https://sourceforge.net/projects/dvbtools"
SRC_URI="mirror://sourceforge/dvbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xml"

RDEPEND="xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/linuxtv-dvb-headers"

src_prepare() {
	epatch "${FILESDIR}"/${PF}-gentoo.diff
	epatch "${FILESDIR}"/${PN}-0.5-stdint.patch
}

src_compile() {
	emake dvbtune

	use xml && emake xml2vdr
}

src_install() {
	dobin dvbtune

	use xml && dobin xml2vdr

	dodoc README scripts/*
}
