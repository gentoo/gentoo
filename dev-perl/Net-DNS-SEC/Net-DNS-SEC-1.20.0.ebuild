# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION='DNSSEC extensions to Net::DNS'
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	>=dev-perl/Crypt-OpenSSL-DSA-0.140.0
	>=dev-perl/Crypt-OpenSSL-RSA-0.270.0
	>=virtual/perl-File-Spec-0.860.0
	>=virtual/perl-MIME-Base64-2.110.0
	>=dev-perl/Net-DNS-1.10.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
