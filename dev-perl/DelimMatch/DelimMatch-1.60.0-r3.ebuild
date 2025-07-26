# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DIST_AUTHOR=NWALSH
DIST_VERSION=1.06a

inherit perl-module

DESCRIPTION="A Perl 5 module for locating delimited substrings with proper nesting"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

S="${WORKDIR}/${DIST_P%%a}"
