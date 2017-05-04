# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILYAZ
DIST_VERSION=1.14
DIST_SECTION=modules
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Module for reading tags of MP3 Audio files"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/MP3-Info"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
