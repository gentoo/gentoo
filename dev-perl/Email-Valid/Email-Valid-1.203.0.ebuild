# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.203
DIST_TEST="do verbose"
inherit perl-module

DESCRIPTION="Check validity of Internet email addresses"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Encode
	virtual/perl-Carp
	virtual/perl-File-Spec
	dev-perl/IO-CaptureOutput
	virtual/perl-IO
	dev-perl/MailTools
	dev-perl/Net-DNS
	>=dev-perl/Net-Domain-TLD-1.650.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
