# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="A completely automatic on-line backup system"
HOMEPAGE="http://boxbackup.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
SRC_URI="http://boxbackup.org/svn/box/packages/${P/_/}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x86-macos"
IUSE="client-only libressl"
DEPEND="sys-libs/zlib
	sys-libs/db:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	virtual/mta"

S="${WORKDIR}/${P/_/}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.11_rc8-testbbackupd.patch
}

src_compile() {
	# bug #299411
	emake -j1 || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
	emake -j1 DESTDIR="${D}" install-backup-client || die "client install failed"
	use client-only || \
		emake -j1 DESTDIR="${D}" install-backup-server || die "server install failed"

	dodoc *.txt
	newinitd "${FILESDIR}"/bbackupd.rc bbackupd
	use client-only || \
		newinitd "${FILESDIR}"/bbstored.rc bbstored

	keepdir /etc/boxbackup

	# apparently new versions have the files in the right location, so this is redundant
	# move executables from /usr/bin to /usr/sbin, as configuration of
	# this is unfortunately not optimal
	#mv "${D%/}${EPREFIX}/usr/bin" "${D%/}${EPREFIX}/usr/sbin" || die "could not move files from bin to sbin"
}

pkg_preinst() {
	if ! use client-only;
	then
		enewgroup bbstored
		enewuser bbstored -1 -1 -1 bbstored
	fi
}

pkg_postinst() {
	while read line; do elog "${line}"; done <<EOF
After configuring the Box Backup client and/or server, you can start
the daemon using the init scripts /etc/init.d/bbackupd and
/etc/init.d/bbstored.
The configuration files can be found in /etc/boxbackup

More information about configuring the client can be found at
${HOMEPAGE}client.html,
and more information about configuring the server can be found at
${HOMEPAGE}server.html.
EOF
	echo
}
