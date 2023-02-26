# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=2.500
inherit perl-module

DESCRIPTION="A library for sending email"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Abstract-3.6.0
	dev-perl/Email-Address
	>=dev-perl/Email-Simple-1.998.0
	>=virtual/perl-File-Path-2.60.0
	virtual/perl-File-Spec
	>=virtual/perl-IO-1.110.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	dev-perl/Module-Runtime
	>=dev-perl/Moo-2.0.0
	>=dev-perl/MooX-Types-MooseLike-0.150.0
	>=virtual/perl-libnet-3.70.0
	dev-perl/Sub-Exporter
	>=dev-perl/Throwable-0.200.3
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=dev-perl/Capture-Tiny-0.80.0
		virtual/perl-Exporter
		virtual/perl-File-Temp
		dev-perl/Sub-Override
		dev-perl/Test-MockObject
		>=virtual/perl-Test-Simple-0.960.0
	)
"
