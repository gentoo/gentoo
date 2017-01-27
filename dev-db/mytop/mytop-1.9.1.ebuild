# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module

DESCRIPTION="mytop - a top clone for mysql"
HOMEPAGE="http://www.mysqlfanboy.com/mytop-3/"
SRC_URI="http://www.mysqlfanboy.com/mytop-3/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-perl/DBD-mysql
	virtual/perl-Getopt-Long
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PATCHES=( "${FILESDIR}/${PN}-1.9.1-global-status.patch"
	  "${FILESDIR}/${PN}-1.9.1-queries-vs-questions-mysql-5.0.76.patch"
	)
SRC_TEST="do"

src_install() {
	perl-module_src_install
	sed -i -r\
		-e "s|socket( +)=> '',|socket\1=> '/var/run/mysqld/mysqld.sock',|g" \
		"${D}"/usr/bin/mytop
}
