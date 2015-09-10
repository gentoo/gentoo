# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="percona-${PN/-bin}"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="MySQL hot backup software that performs non-blocking backups for
InnoDB and XtraDB databases"
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

DEPEND=""
RDEPEND="dev-libs/libaio
	|| ( dev-libs/libgcrypt:0/11 dev-libs/libgcrypt:11/11 )
	dev-libs/libgpg-error
	dev-perl/DBD-mysql
	sys-libs/zlib"

if use amd64; then
	S="${WORKDIR}/${MY_P}-Linux-x86_64"
elif use x86; then
	S="${WORKDIR}/${MY_P}-Linux-i686"
fi

src_prepare() {
	# bug 501904 - CVE-2014-2029
	epatch "${FILESDIR}/${PN}-2.1.7-no-versioncheck.patch"
}

src_install() {
	for tool in innobackupex xbcrypt xbstream xtrabackup; do
		dobin bin/${tool}
		doman man/man1/${tool}.1
	done
}

pkg_postinst() {
	einfo "xtrabackup 2.2.x is for MySQL/MariaDB 5.6 only"
}
