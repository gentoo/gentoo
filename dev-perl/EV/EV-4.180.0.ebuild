# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/EV/EV-4.180.0.ebuild,v 1.1 2015/05/10 18:29:59 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=4.18
inherit perl-module

DESCRIPTION="Perl interface to libev, a high performance full-featured event loop"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
