# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Parser-Lite/XML-Parser-Lite-0.720.0.ebuild,v 1.2 2015/04/03 08:56:42 zlogene Exp $

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=0.72
inherit perl-module

DESCRIPTION="Lightweight regexp-based XML parser"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
