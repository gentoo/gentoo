# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KARASIK
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Shared secret elliptic-curve Diffie-Hellman generator"

LICENSE="|| ( Artistic GPL-1+ ) BSD CC-PD"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
