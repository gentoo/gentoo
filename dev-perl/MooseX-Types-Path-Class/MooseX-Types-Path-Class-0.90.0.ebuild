# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="A Path::Class type library for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/MooseX-Types
	>=dev-perl/Path-Class-0.160.0
	virtual/perl-if
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		!minimal? ( dev-perl/MooseX-Getopt )
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		dev-perl/Moose
		dev-perl/Test-Needs
		virtual/perl-Test-Simple
	)
"
