# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

MY_P="${P/bw/}"

DESCRIPTION="Perl-based whois client designed to work with the new Shared Registration System"
SRC_URI="http://whois.bw.org/dist/${MY_P}.tgz"
HOMEPAGE="http://whois.bw.org/"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# bug #440390
	sed -i -e '/^\.ru/s/ripn.ru/ripn.net/' tld.conf || die 'sed on tld.conf failed'
	perl-module_src_prepare
}

src_install() {
	exeinto usr/bin
	newexe whois bwwhois

	newman whois.1 bwwhois.1

	insinto /etc/whois
	doins whois.conf tld.conf sd.conf

	perl_set_version
	insinto "${VENDOR_LIB}"
	doins bwInclude.pm

	dodoc HISTORY INSTALL README
}
