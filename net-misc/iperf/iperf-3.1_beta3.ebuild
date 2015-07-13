# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/iperf/iperf-3.1_beta3.ebuild,v 1.1 2015/07/13 04:40:29 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="A TCP, UDP, and SCTP network bandwidth measurement tool"
LICENSE="BSD"
SLOT="3"
HOMEPAGE="https://github.com/esnet/iperf/"
SRC_URI="https://codeload.github.com/esnet/${PN}/tar.gz/${PV/_beta/b} -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="static-libs"

S=${WORKDIR}/${P/_beta/b}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.5-flags.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
