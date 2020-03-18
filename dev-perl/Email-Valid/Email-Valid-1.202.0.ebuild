# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.202
inherit perl-module

DESCRIPTION="Check validity of Internet email addresses"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	dev-perl/IO-CaptureOutput
	virtual/perl-IO
	dev-perl/MailTools
	dev-perl/Net-DNS
	>=dev-perl/Net-Domain-TLD-1.650.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
