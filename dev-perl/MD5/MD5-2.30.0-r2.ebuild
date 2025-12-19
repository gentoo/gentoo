# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=2.03
inherit perl-module

DESCRIPTION="The Perl MD5 Module"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

RDEPEND="virtual/perl-Digest-MD5"
BDEPEND="${RDEPEND}"
