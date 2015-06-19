# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mrtg-ping-probe/mrtg-ping-probe-2.2.0.ebuild,v 1.6 2014/07/13 14:12:47 jer Exp $

EAPI=5

DESCRIPTION="Addon mrtg contrib for stats ping/loss packets"
SRC_URI="ftp://ftp.pwo.de/pub/pwo/mrtg/${PN}/${P}.tar.gz"
HOMEPAGE="http://pwo.de/projects/mrtg/"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-lang/perl"
RDEPEND="
	${DEPEND}
	net-analyzer/mrtg
"

src_prepare() {
	sed -i check-ping-fmt \
		-e 's:#!/usr/local/bin/perl -w:#!/usr/bin/perl -w:' \
		|| die
	sed -i mrtg-ping-probe \
		-e 's:#!/bin/perl:#!/usr/bin/perl:' \
		|| die
}

src_install () {
	dodoc ChangeLog NEWS README TODO mrtg.cfg-ping
	doman mrtg-ping-probe.1
	dobin check-ping-fmt mrtg-ping-probe "${FILESDIR}"/mrtg-ping-cfg
}
