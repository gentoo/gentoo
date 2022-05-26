# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.05
DIST_AUTHOR=GMPASSOS
inherit perl-module

DESCRIPTION="Perl Objects as Hash, Array, Scalar, Code and Glob at the same time"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
