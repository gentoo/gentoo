# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NJH
DIST_VERSION=0.06
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl interface for the MusicBrainz libdiscid library"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
	test? (
		>=virtual/perl-Test-1.0.0
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( t/05pod.t )
