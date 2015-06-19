# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mytop/mytop-1.6-r4.ebuild,v 1.6 2014/03/24 15:03:13 ago Exp $

EAPI=5

inherit perl-module

DESCRIPTION="mytop - a top clone for mysql"
HOMEPAGE="http://jeremy.zawodny.com/mysql/mytop/"
SRC_URI="http://jeremy.zawodny.com/mysql/mytop/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ppc sparc x86"
SLOT="0"
IUSE=""

RDEPEND="dev-perl/DBD-mysql
	virtual/perl-Getopt-Long
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PATCHES=( "${FILESDIR}/${PN}-1.6-global-status.patch"
		  "${FILESDIR}/${PN}-1.6-queries-vs-questions-mysql-5.0.76.patch"
		  "${FILESDIR}/${PN}-1.6-getopt-long-2.38-fixup.patch"
		)
SRC_TEST="do"

src_install() {
	perl-module_src_install
	sed -i -r\
		-e "s|socket( +)=> '',|socket\1=> '/var/run/mysqld/mysqld.sock',|g" \
		"${D}"/usr/bin/mytop
}
