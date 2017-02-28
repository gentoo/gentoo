# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="a thing with a list of tags"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# r: Moose::Role -> Moose
# r: Moose::Util::TypeConstraints -> Moose
RDEPEND="
	dev-perl/Moose
"
# t: IO::Handle -> IO
# t: IPC::Open3 -> perl
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.960.0
	)
"
