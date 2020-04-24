# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Swiss Army Knife SMTP; Command line SMTP testing, including TLS and AUTH"
HOMEPAGE="https://www.jetmore.org/john/code/swaks"
SRC_URI="https://www.jetmore.org/john/code/swaks/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="ssl"

DEPEND=">=dev-lang/perl-5.8.8"

RDEPEND="${DEPEND}
		>=dev-perl/Net-DNS-0.65
		ssl? ( >=dev-perl/Net-SSLeay-1.35 )
		>=virtual/perl-MIME-Base64-3.07
		>=virtual/perl-Digest-MD5-2.39
		>=virtual/perl-Time-HiRes-1.97
		>=virtual/perl-Time-Local-1.19
		>=dev-perl/Authen-NTLM-1.02
		>=dev-perl/Authen-DigestMD5-0.04
		virtual/perl-Digest-SHA"

src_compile() {
	/usr/bin/pod2man -s 1 doc/ref.pod swaks.1 || die "man page compulation failed"
}

src_install() {
	dobin swaks
	doman swaks.1
	dodoc README.txt doc/*.txt
}
