# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SFINK
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Human-readable unit-aware calculator"

SLOT="0"
KEYWORDS="amd64 ~hppa sparc x86"

RDEPEND="virtual/perl-Time-Local"
BDEPEND="${RDEPEND}"
