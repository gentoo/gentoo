# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILYAZ
DIST_VERSION=1.16
DIST_SECTION=modules
DIST_A_EXT="zip"
DIST_EXAMPLES=("examples/*")
# somewhat flaky
DIST_TEST=do
inherit perl-module

DESCRIPTION="Module for reading tags of MP3 Audio files"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	dev-perl/MP3-Info
"
BDEPEND="
	${RDEPEND}
	app-arch/unzip
	virtual/perl-ExtUtils-MakeMaker
"
