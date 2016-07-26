# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN=MySQLTuner-perl

DESCRIPTION="MySQLTuner is a high-performance MySQL tuning script"
HOMEPAGE="http://www.mysqltuner.com/"
SRC_URI="https://github.com/major/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5.6
	virtual/perl-Getopt-Long
	>=virtual/mysql-3.23"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	newbin "${PN}.pl" "${PN}"

	# The passwords are meant to be fed to the script uncompressed.
	docompress -x "/usr/share/doc/${PF}/basic_passwords.txt"
	dodoc README.* USAGE.md CONTRIBUTING.md INTERNALS.md basic_passwords.txt
}
