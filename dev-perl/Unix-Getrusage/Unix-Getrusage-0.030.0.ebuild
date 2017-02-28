# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TAFFY
MODULE_VERSION=0.03

inherit perl-module

DESCRIPTION="Perl interface to the Unix getrusage system call"

SLOT="0"
KEYWORDS="amd64 ~mips x86"

SRC_TEST="do parallel"
