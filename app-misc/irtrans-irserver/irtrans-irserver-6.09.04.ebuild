# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/irtrans-irserver/irtrans-irserver-6.09.04.ebuild,v 1.1 2015/06/26 02:28:23 idella4 Exp $

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs mono-env multilib

RESTRICT="strip"

DESCRIPTION="IRTrans Server"
HOMEPAGE="http://www.irtrans.de"
SRC_URI="http://ftp.disconnected-by-peer.at/irtrans/irserver-src-${PV}.tar.gz
	 http://ftp.disconnected-by-peer.at/irtrans/irserver-${PV}.tar.gz
	http://www.irtrans.de/download/Server/Linux/irserver-src.tar.gz -> irserver-src-${PV}.tar.gz
	http://www.irtrans.de/download/Server/Linux/irserver.tar.gz -> irserver-${PV}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE="mono"

RDEPEND="mono? ( >=dev-lang/mono-2.10.5 )"

S="${WORKDIR}"

src_prepare() {
	sed -e 's!^ODIRARM = .*!ODIRARM = n800!' -i makefile
}

src_compile() {
	append-flags -DLINUX -DMEDIACENTER
	append-ldflags --static

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
	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" "${irbuild}"
}

src_install() {
	newbin "${WORKDIR}/${irserver}" irserver

	keepdir /etc/irserver/remotes

	docinto remotes
	dodoc remotes/*

	newinitd "${FILESDIR}"/irtrans-server.initd irtrans-server
	newconfd "${FILESDIR}"/irtrans-server.confd irtrans-server

	if use mono ; then
		# Wrapper script to launch mono
		make_wrapper irguiclient "mono /usr/$(get_libdir)/${PN}/GUIClient.exe"

		insinto /usr/$(get_libdir)/${PN}/
		exeinto /usr/$(get_libdir)/${PN}/

		# The Libs and Translations
		doins GUIClient/*.tra
		doexe GUIClient/*.dll

		# The actual executable
		doexe GUIClient/*.exe
	fi
}
