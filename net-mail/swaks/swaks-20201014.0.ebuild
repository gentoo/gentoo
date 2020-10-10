# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="Swiss Army Knife SMTP; Command line SMTP testing, including TLS and AUTH"
HOMEPAGE="https://www.jetmore.org/john/code/swaks/
https://github.com/jetmore/swaks"
SRC_URI="http://www.jetmore.org/john/code/swaks/${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/Authen-DigestMD5-0.04
	>=dev-perl/Authen-NTLM-1.02
	>=dev-perl/Net-DNS-0.65
	>=virtual/perl-Digest-MD5-2.39
	>=virtual/perl-MIME-Base64-3.07
	>=virtual/perl-Time-HiRes-1.97
	>=virtual/perl-Time-Local-1.19
	dev-perl/CGI
	dev-perl/DBI
	dev-perl/Email-Send
	dev-perl/Email-Valid
	dev-perl/Params-Validate
	dev-perl/URI
	virtual/perl-Data-Dumper
	virtual/perl-Digest-SHA
	virtual/perl-Getopt-Long
"
BDEPEND="app-text/txt2man"

src_compile() {
	/usr/bin/txt2man -s 1 -t "${PN}" -v "Mail tools" doc/ref.txt \
		> swaks.1 \
		|| die "man page compulation failed"
}

src_install() {
	dobin swaks
	doman swaks.1
	dodoc README.txt doc/*.txt
}

pkg_postinst() {
	optfeature "ssl" dev-perl/IO-Socket-SSL
}
