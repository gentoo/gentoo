# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/irtrans-irserver/irtrans-irserver-6.03.09.ebuild,v 1.1 2011/03/29 20:08:16 hd_brummy Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

RESTRICT="strip"

DESCRIPTION="IRTrans Server"
HOMEPAGE="http://www.irtrans.de"
SRC_URI="http://www.irtrans.de/download/Server/Linux/irserver-src.tar.gz -> irserver-src-${PV}.tar.gz
	http://ftp.disconnected-by-peer.at/irtrans/irserver-src-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${P}"-arm-1.patch
}

src_compile() {

	append-flags -DLINUX

	# Set sane defaults (arm target has no -D flags added)
	irbuild=irserver_arm_noccf
	irserver=irserver

	# change variable by need
	if use x86 ; then
		irbuild=irserver
	elif use amd64 ; then
		irbuild=irserver64
		irserver=irserver64
	elif use arm ; then
		irbuild=irserver_arm
	fi

	# Some output for bugreport
	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "Build Target=\"${irbuild}\""
	einfo "Build Binary=\"${irserver}\""

	# Build
	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" "${irbuild}" || die "emake irserver failed"
}

src_install() {

	newbin "${WORKDIR}/${irserver}" irserver

	keepdir /etc/irserver/remotes

	docinto remotes
	dodoc remotes/*

	newinitd "${FILESDIR}"/irtrans-server.initd irtrans-server
	newconfd "${FILESDIR}"/irtrans-server.confd irtrans-server
}
