# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CSS-Squish/CSS-Squish-0.100.0-r1.ebuild,v 1.1 2014/08/26 17:21:59 axs Exp $

EAPI=5

MODULE_AUTHOR=TSIBLEY
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Compact many CSS files into one big file"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="dev-perl/URI
	virtual/perl-File-Spec"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Test-LongString )"

SRC_TEST="do"
