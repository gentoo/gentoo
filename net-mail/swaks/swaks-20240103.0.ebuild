# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Swiss Army Knife SMTP; Command line SMTP testing, including TLS and AUTH"
HOMEPAGE="https://www.jetmore.org/john/code/swaks/
	https://github.com/jetmore/swaks"
SRC_URI="https://www.jetmore.org/john/code/swaks/${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

RDEPEND="
	virtual/perl-Getopt-Long
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
	# See https://github.com/jetmore/swaks/blob/v20240103.0/swaks#L1933-L1953
	local header="Install the following additional packages for optional runtime features.\n"
	header+="You may also check the output of 'swaks --support' to list currently available features:"
	optfeature_header "$header"
	optfeature "Basic auth support" virtual/perl-MIME-Base64
	optfeature "AUTH CRAM-MD5 support" virtual/perl-Digest-MD5
	optfeature "AUTH CRAM-SHA1 support" virtual/perl-Digest-SHA
	optfeature "AUTH NTLM support" dev-perl/Authen-NTLM
	optfeature "AUTH DIGEST-MD5 support" dev-perl/Authen-SASL
	optfeature "MX routing support" dev-perl/Net-DNS
	optfeature "TLS support" dev-perl/Net-SSLeay
	optfeature "High Resolution Timing support" virtual/perl-Time-HiRes
}
