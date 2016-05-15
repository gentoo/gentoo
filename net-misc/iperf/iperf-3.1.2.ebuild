# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="A TCP, UDP, and SCTP network bandwidth measurement tool"
LICENSE="BSD"
SLOT="3"
HOMEPAGE="https://github.com/esnet/iperf/"
SRC_URI="https://codeload.github.com/esnet/${PN}/tar.gz/${PV/_beta/b} -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="static-libs sctp"

DEPEND="sctp? ( net-misc/lksctp-tools )"
RDEPEND="$DEPEND"

S=${WORKDIR}/${P/_beta/b}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.5-flags.patch

	eapply_user

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	newconfd "${FILESDIR}"/iperf.confd iperf3
	newinitd "${FILESDIR}"/iperf3.initd iperf3
	prune_libtool_files
}
