# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/irtrans-irclient/irtrans-irclient-6.01.05.ebuild,v 1.2 2011/02/02 11:54:04 hd_brummy Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

RESTRICT="strip"

DESCRIPTION="IRTrans Server"
HOMEPAGE="http://www.irtrans.de"
SRC_URI="http://www.irtrans.de/download/Client/irclient-src.tar.gz -> irclient-src-${PV}.tar.gz
	http://ftp.disconnected-by-peer.at/irtrans/${PN}-5.11.04-ip_assign-1.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${RDEPND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${WORKDIR}/${PN}"-5.11.04-ip_assign-1.patch
}

src_compile() {

	append-flags -DLINUX

	# Set sane defaults (arm target has no -D flags added)
	irbuild=irclient_arm
	irclient=irclient
	ipbuild=ip_assign_arm
	ip_assign=ip_assign

	# change variable by need
	if use x86 ; then
		irbuild=irclient
		ipbuild=ip_assign
	elif use amd64 ; then
		irbuild=irclient64
		irclient=irclient64
		ipbuild=ip_assign64
		ip_assign=ip_assign64
	fi

	# Some output for bugreport
	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "Build client Target=\"${irbuild}\""
	einfo "Build client Binary=\"${irclient}\""
	einfo "Build ip_assign Target=\"${ipbuild}\""
	einfo "Build ip_assign Binary=\"${ip_assign}\""

	# Build
	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" "${irbuild}" || die "emake irclient failed"
	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" "${ipbuild}" || die "emake ip_assign failed"
}

src_install() {

	newbin "${WORKDIR}/${irclient}" irclient
	newbin "${WORKDIR}/${ip_assign}" ip_assign
}
