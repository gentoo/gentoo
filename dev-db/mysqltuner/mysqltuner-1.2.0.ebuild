# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysqltuner/mysqltuner-1.2.0.ebuild,v 1.3 2011/12/14 09:13:46 phajdan.jr Exp $

EAPI=4

DESCRIPTION="MySQLTuner is a high-performance MySQL tuning script"
HOMEPAGE="http://www.mysqltuner.com"
SRC_URI="https://github.com/rackerhacker/MySQLTuner-perl/tarball/05813a1faa447fe16c2a7efdab9b22c3bcbc5485 -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5.6
	virtual/perl-Getopt-Long
	>=virtual/mysql-3.23"

S="${WORKDIR}"/rackerhacker-MySQLTuner-perl-05813a1

src_install() {
	mv "${PN}".pl "${PN}"
	dobin "${PN}"
	dodoc README
}
