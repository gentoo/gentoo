# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/mylvmbackup/mylvmbackup-0.14.ebuild,v 1.1 2013/12/28 01:44:12 robbat2 Exp $

DESCRIPTION="mylvmbackup is a tool for quickly creating backups of MySQL server's data files using LVM snapshots"
HOMEPAGE="http://lenzg.net/mylvmbackup/"
SRC_URI="http://lenzg.net/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""
RDEPEND="dev-perl/Config-IniFiles
		>=sys-fs/lvm2-2.02.06
		dev-perl/DBD-mysql
		virtual/mysql
		dev-perl/TimeDate"

src_unpack() {
	unpack ${A}
	sed -i \
		-e '/^prefix/s,/usr/local,/usr,' \
		"${S}"/Makefile
	sed -i 's|mycnf=/etc/my.cnf|mycnf=/etc/mysql/my.cnf|' "${S}"/mylvmbackup.conf
}

src_install() {
	emake install DESTDIR="${D}" mandir="/usr/share/man" || die
	dodoc ChangeLog README TODO
	keepdir /var/tmp/${PN}/{backup,mnt}
	fperms 0700 /var/tmp/${PN}/
}
