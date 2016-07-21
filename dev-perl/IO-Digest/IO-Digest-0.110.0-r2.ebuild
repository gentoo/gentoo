# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CLKAO
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="IO::Digest - Calculate digests while reading or writing"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=dev-perl/PerlIO-via-dynamic-0.10
	virtual/perl-Digest"
DEPEND="${RDEPEND}"

SRC_TEST="do"
