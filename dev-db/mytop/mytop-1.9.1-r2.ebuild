# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_TEST="do"
inherit perl-module

DESCRIPTION="mytop - a top clone for mysql"
HOMEPAGE="http://www.mysqlfanboy.com/mytop-3/"
SRC_URI="http://www.mysqlfanboy.com/mytop-3/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ppc sparc x86"
SLOT="0"

RDEPEND="
	dev-perl/DBD-mysql
	dev-perl/TermReadKey
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-global-status.patch
	"${FILESDIR}"/${PN}-1.9.1-queries-vs-questions-mysql-5.0.76.patch
)

src_install() {
	perl-module_src_install
	sed -i -r \
		-e "s|socket( +)=> '',|socket\1=> '/var/run/mysqld/mysqld.sock',|g" \
		"${ED}"/usr/bin/mytop || die
}
