# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.200
inherit perl-module

DESCRIPTION="Local delivery of RFC2822 message format and headers"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Simple-1.998.0
	>=dev-perl/Email-FolderType-0.700.0
	virtual/perl-File-Path
	>=dev-perl/File-Path-Expand-1.10.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
