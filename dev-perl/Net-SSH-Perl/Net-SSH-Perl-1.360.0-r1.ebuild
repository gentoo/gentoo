# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SCHWIGON
MODULE_VERSION=1.36
inherit perl-module

DESCRIPTION="Perl client Interface to SSH"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	virtual/perl-Digest-MD5
	>=dev-perl/String-CRC32-1.2
	>=dev-perl/Math-GMP-1.04
	>=dev-perl/Math-Pari-2.001804
	>=dev-perl/Digest-SHA1-2.10
	dev-perl/Digest-HMAC
	dev-perl/Crypt-DH
	>=dev-perl/Crypt-DSA-0.110.0
	virtual/perl-MIME-Base64
	>=dev-perl/Convert-PEM-0.05
	dev-perl/Crypt-Blowfish
	dev-perl/Crypt-DES
	dev-perl/Crypt-IDEA
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/Crypt-RSA
	dev-perl/Digest-BubbleBabble"
RDEPEND="${DEPEND}"

#src_compile() {
#	echo "" | perl-module_src_compile
#}
SRC_TEST=do
