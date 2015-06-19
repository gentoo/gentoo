# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Contextual-Return/Contextual-Return-0.4.7-r1.ebuild,v 1.1 2014/08/26 17:20:30 axs Exp $

EAPI=5

MODULE_AUTHOR=DCONWAY
MODULE_VERSION=0.004007
inherit perl-module

DESCRIPTION="Create context-sensitive return values"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE=""

RDEPEND="
	dev-perl/Want
	virtual/perl-version
"
DEPEND="${RDEPEND}
"

SRC_TEST=do
