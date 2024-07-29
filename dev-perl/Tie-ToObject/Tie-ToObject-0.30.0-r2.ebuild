# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NUFFIN
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Tie to an existing object"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND=""
BDEPEND="test? ( >=virtual/perl-Test-Simple-1.1.10 )"
