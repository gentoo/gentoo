# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Uniqid/Data-Uniqid-0.120.0-r1.ebuild,v 1.1 2014/08/23 02:43:54 axs Exp $

EAPI=5

MODULE_AUTHOR="MWX"
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Perl extension for simple generating of unique ids"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	virtual/perl-Math-BigInt
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
