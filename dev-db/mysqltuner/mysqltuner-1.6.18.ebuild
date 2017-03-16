# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long
	virtual/mysql"

DOCS=( USAGE.md CONTRIBUTING.md INTERNALS.md basic_passwords.txt vulnerabilities.csv )
S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	newbin "${PN}.pl" "${PN}"

	# The passwords and vulnerabilities are meant to be fed to the script uncompressed
	docompress -x "/usr/share/doc/${PF}/basic_passwords.txt" "/usr/share/doc/${PF}/vulnerabilities.csv"
	einstalldocs
}
