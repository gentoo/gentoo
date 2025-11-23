# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.035
inherit perl-module

DESCRIPTION="Simple filtering of RFC2822 message format and headers"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-perl/Class-Trigger
	dev-perl/Email-LocalDelivery
	dev-perl/Email-Simple
	dev-perl/IPC-Run
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
	)
"
