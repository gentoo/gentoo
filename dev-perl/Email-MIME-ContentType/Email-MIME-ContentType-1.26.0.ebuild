# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJBS
DIST_VERSION=1.026
inherit perl-module

DESCRIPTION="Parse a MIME Content-Type Header or Content-Disposition Header"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Encode-2.870.0
	>=virtual/perl-Exporter-5.570.0
	dev-perl/Text-Unidecode
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
