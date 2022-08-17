# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MySQLTuner-perl"

DESCRIPTION="Makes recommendations for increased performance and stability for MySQL"
HOMEPAGE="https://github.com/major/MySQLTuner-perl"
SRC_URI="https://github.com/major/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long
"

DEPEND="${RDEPEND}"

src_install() {
	newbin mysqltuner.pl mysqltuner
	dodoc {CONTRIBUTING,INTERNALS,USAGE}.md
	einstalldocs

	# Passwords and vulnerabilities are meant to be fed to the script uncompressed.
	dodoc basic_passwords.txt vulnerabilities.csv
	docompress -x "/usr/share/doc/${PF}/basic_passwords.txt" "/usr/share/doc/${PF}/vulnerabilities.csv"
}
