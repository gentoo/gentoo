# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Digest/IO-Digest-0.110.0-r2.ebuild,v 1.2 2014/08/28 11:52:14 zlogene Exp $

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
