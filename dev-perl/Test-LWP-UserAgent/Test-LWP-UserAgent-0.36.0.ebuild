# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.036
inherit perl-module

DESCRIPTION="A LWP::UserAgent suitable for simulating and testing network calls"

SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/HTTP-Date
	dev-perl/HTTP-Message
	dev-perl/libwww-perl
	dev-perl/Safe-Isa
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	dev-perl/Try-Tiny
	dev-perl/URI
	>=dev-perl/namespace-clean-0.190.0
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		virtual/perl-File-Spec
		dev-perl/Path-Tiny
		>=dev-perl/Test-Deep-0.110.0
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Needs
		dev-perl/Test-RequiresInternet
		>=dev-perl/Test-Warnings-0.9.0
		virtual/perl-if
	)
"
