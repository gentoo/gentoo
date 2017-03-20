# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="A completely automatic on-line backup system"
HOMEPAGE="http://boxbackup.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
SRC_URI="http://boxbackup.org/svn/box/packages/${P/_/}.tgz"

# GPL-2 is included for the init script, bug 425884.
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~ppc-macos ~x86-macos"
IUSE="client-only libressl"
DEPEND="sys-libs/zlib
	sys-libs/db:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	virtual/mta"

S="${WORKDIR}/${P/_/}"

PATCHES=(
	"${FILESDIR}/${PN}-0.11_rc8-testbbackupd.patch"
	"${FILESDIR}/${PN}-0.11.1-fix-Wformat-security.patch"
	"${FILESDIR}/${PN}-0.11.1-fix-mandir.patch"
)

src_compile() {
	# Bug 299411.
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	emake -j1 DESTDIR="${D}" install-backup-client

	dodoc BUGS.txt CONTACT.txt DOCUMENTATION.txt ExceptionCodes.txt THANKS.txt
	newinitd "${FILESDIR}"/bbackupd.rc bbackupd

	if ! use client-only ; then
		emake -j1 DESTDIR="${D}" install-backup-server
		newinitd "${FILESDIR}"/bbstored.rc bbstored
	fi

	keepdir /etc/boxbackup
}

pkg_preinst() {
	if ! use client-only ; then
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
