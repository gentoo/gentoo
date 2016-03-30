# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Compile .cgi scripts to a code reference like ModPerl::Registry"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/File-pushd
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/Test-NoWarnings
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
	)
"
