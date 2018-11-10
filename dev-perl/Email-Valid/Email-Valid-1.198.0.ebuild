# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.198
inherit perl-module

DESCRIPTION="Check validity of Internet email addresses"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-linux"
IUSE="test"

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
