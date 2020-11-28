# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature perl-functions

DESCRIPTION="Swiss Army Knife SMTP; Command line SMTP testing, including TLS and AUTH"
HOMEPAGE="https://www.jetmore.org/john/code/swaks/
	https://github.com/jetmore/swaks"
SRC_URI="http://www.jetmore.org/john/code/swaks/${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-perl/Authen-DigestMD5
	dev-perl/Authen-NTLM
	dev-perl/CGI
	dev-perl/DBI
	dev-perl/Email-Send
	dev-perl/Email-Valid
	dev-perl/Net-DNS
	dev-perl/Params-Validate
	dev-perl/URI
	virtual/perl-Data-Dumper
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-Getopt-Long
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
"
BDEPEND="app-text/txt2man"

src_compile() {
	txt2man -s 1 -t "swaks" -v "Mail tools" doc/ref.txt \
		> swaks.1 \
		|| die "man page compilation failed"
}

src_install() {
	dobin swaks
	doman swaks.1
	dodoc README.txt doc/*.txt
}

pkg_postinst() {
	optfeature "ssl" dev-perl/IO-Socket-SSL
}
