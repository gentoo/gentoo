# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Displays various tables of DNS traffic on your network"
HOMEPAGE="http://dnstop.measurement-factory.com/"
SRC_URI="http://dnstop.measurement-factory.com/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
IUSE="ipv6"

RDEPEND="sys-libs/ncurses:0
	net-libs/libpcap[ipv6?]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

src_configure() {
	if has_version sys-libs/ncurses:0[tinfo] ; then
		append-libs -ltinfo	#bug 595068
	fi
	econf \
		$(use_enable ipv6)
}

src_install() {
	dobin dnstop
	doman dnstop.8
	dodoc CHANGES
}
