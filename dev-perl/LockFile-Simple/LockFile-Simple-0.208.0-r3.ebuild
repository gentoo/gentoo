# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SCHWIGON
DIST_SECTION=lockfile-simple
DIST_VERSION=0.208
inherit perl-module

DESCRIPTION="File locking module for Perl"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"

DIST_TEST=do
