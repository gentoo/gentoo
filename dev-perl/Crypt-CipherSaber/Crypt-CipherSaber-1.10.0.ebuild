# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Perl module implementing CipherSaber encryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.4.2
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.600.0
		>=dev-perl/Test-Warn-0.300.0
	)
"
