# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHILLI
DIST_VERSION=0.48
DIST_EXAMPLES=( "eg/ask" "eg/mkperl" "eg/perm_cp" "eg/tap" "eg/untar_in" )
inherit perl-module

DESCRIPTION="Typical installation tasks for system administrators"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hammer"

RDEPEND="
	>=virtual/perl-File-Temp-0.160.0
	>=dev-perl/File-Which-0.160.0
	dev-perl/libwww-perl
	>=dev-perl/Log-Log4perl-1.280.0
	dev-perl/TermReadKey
	hammer? ( dev-perl/Expect )"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
