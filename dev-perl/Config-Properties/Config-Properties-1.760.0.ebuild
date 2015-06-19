# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-Properties/Config-Properties-1.760.0.ebuild,v 1.1 2014/02/19 10:58:46 radhermit Exp $

EAPI="5"

MODULE_AUTHOR=SALVA
MODULE_VERSION=1.76
inherit perl-module

DESCRIPTION="Configuration using Java style properties"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)"

SRC_TEST="do"
