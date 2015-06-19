# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Fast/XML-Fast-0.110.0-r1.ebuild,v 1.1 2014/08/23 01:25:35 axs Exp $

EAPI=5

MODULE_AUTHOR=MONS
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Simple and very fast XML to hash conversion"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

SRC_TEST=do
