# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="percona-${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MySQL hot backup software. non-blocking backups for InnoDB/XtraDB databases"
HOMEPAGE="http://www.percona.com/software/percona-xtrabackup"
SRC_URI="
	amd64? (
		http://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-${PV}/binary/tarball/${MY_P}-Linux-x86_64.tar.gz
	)
	x86? (
		http://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-${PV}/binary/tarball/${MY_P}-Linux-i686.tar.gz
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# NOTE: dev-perl/DBD-mysql still necessary, now for bin/xtrabackup?
DEPEND=""
RDEPEND="dev-libs/libaio
	dev-libs/libgcrypt:11/11
	dev-libs/libgpg-error
	dev-perl/DBD-mysql
	sys-libs/zlib"

src_unpack() {
	default

	if use amd64; then
		S="${WORKDIR}/${MY_P}-Linux-x86_64"
	elif use x86; then
		S="${WORKDIR}/${MY_P}-Linux-i686"
	fi
}

src_install() {
	# Two new tools with an old libcurl.so.3 dep...
	# TODO: Wait for a new release using libcurl.so.4
	# net-misc/curl dev-libs/libev
	# dobin bin/xbcloud{,_osenv}

	for tool in xbcrypt xbstream xtrabackup; do
		dobin bin/${tool}
	done

	for man in innobackupex xbcrypt xbstream xtrabackup; do
		doman man/man1/${man}.1
	done

	dosym xtrabackup /usr/bin/innobackupex
}

pkg_postinst() {
	ewarn "innobackupex got deprecated in 2.3.x series and is just a symlink to xtrabackup"
}
