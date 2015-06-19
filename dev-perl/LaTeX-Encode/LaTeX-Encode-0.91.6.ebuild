# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/LaTeX-Encode/LaTeX-Encode-0.91.6.ebuild,v 1.4 2015/01/31 14:02:06 zlogene Exp $

EAPI=5

MODULE_AUTHOR=EINHVERFR
MODULE_VERSION=0.091.6
inherit perl-module

DESCRIPTION="Encode characters for LaTeX formatting"

LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/HTML-Parser
	dev-perl/Pod-LaTeX
	dev-perl/Readonly
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
