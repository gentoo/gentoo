# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit base

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="http://iperf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="HPND"
SLOT="2"
KEYWORDS="amd64 ~arm hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="ipv6 threads debug"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-bandwidth-limit.patch
	"${FILESDIR}"/${PN}-cast-to-max_size_t-instead-of-int.patch
	"${FILESDIR}"/${PN}-die-on-bind-fail.patch
	"${FILESDIR}"/${PN}-bidirectional-tcp-server.patch
	"${FILESDIR}"/${PN}-fix-format-security-ftbfs.patch
	"${FILESDIR}"/${PN}-ipv6_mcast_check.patch
	)
DOCS="INSTALL README"

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable threads) \
		$(use_enable debug debuginfo)
}

src_install() {
	default
	dohtml doc/*
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
