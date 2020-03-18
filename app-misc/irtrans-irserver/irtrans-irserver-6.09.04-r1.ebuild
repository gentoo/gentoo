# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic toolchain-funcs mono-env

DESCRIPTION="Server software for IRTrans"
HOMEPAGE="http://www.irtrans.de"
SRC_URI="http://ftp.disconnected-by-peer.at/irtrans/irserver-src-${PV}.tar.gz
	 http://ftp.disconnected-by-peer.at/irtrans/irserver-${PV}.tar.gz
	http://www.irtrans.de/download/Server/Linux/irserver-src.tar.gz -> irserver-src-${PV}.tar.gz
	http://www.irtrans.de/download/Server/Linux/irserver.tar.gz -> irserver-${PV}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="mono"
RESTRICT="strip"

RDEPEND="mono? ( >=dev-lang/mono-2.10.5 )"

S="${WORKDIR}"

src_prepare() {
	default
	sed -e 's!^ODIRARM = .*!ODIRARM = n800!' -i makefile || die
}

src_compile() {
	append-flags -DLINUX -DMEDIACENTER
	append-ldflags --static

	# Set sane defaults (arm target has no -D flags added)
	local irbuild=irserver_arm_noccf
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

	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" "${irbuild}"
}

src_install() {
	newbin "${WORKDIR}/${irserver}" irserver

	keepdir /etc/irserver/remotes

	docinto remotes
	dodoc -r remotes

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
