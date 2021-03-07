# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MSCHOUT
DIST_VERSION=3.30
inherit perl-module

DESCRIPTION="Perl Authentication and Authorization via cookies"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=www-apache/mod_perl-2
	virtual/perl-Carp
	>=dev-perl/Class-Load-0.30.0
	virtual/perl-Encode
	dev-perl/HTTP-Body
	dev-perl/Hash-MultiValue
	dev-perl/WWW-Form-UrlEncoded
	>=dev-perl/URI-1.360.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Apache-Test-1.390.0
		>=virtual/perl-Test-Simple-0.940.0
		!www-apache/mpm_itk
	)
"
src_test() {
	perl_rm_files t/author-* t/signature.t
	perl-module_src_test
}
