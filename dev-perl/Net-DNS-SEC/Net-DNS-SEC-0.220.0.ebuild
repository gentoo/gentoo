# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-DNS-SEC/Net-DNS-SEC-0.220.0.ebuild,v 1.1 2015/03/17 14:54:53 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=NLNETLABS
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION='DNSSEC extensions to Net::DNS'
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	>=dev-perl/Crypt-OpenSSL-DSA-0.100.0
	>=dev-perl/Crypt-OpenSSL-RSA-0.190.0
	>=virtual/perl-Digest-SHA-5.230.0
	virtual/perl-MIME-Base64
	>=dev-perl/Net-DNS-0.690.0
	>=virtual/perl-Test-Simple-0.470.0
	virtual/perl-Time-Local
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

SRC_TEST="do"
