# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.001001
inherit perl-module

DESCRIPTION="Turn STDOUT and STDERR into Test2 events"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="virtual/perl-Test2-Suite"
