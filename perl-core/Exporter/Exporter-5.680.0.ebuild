# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Exporter/Exporter-5.680.0.ebuild,v 1.3 2015/06/04 21:59:58 dilfridge Exp $
EAPI=5
MODULE_AUTHOR=TODDR
MODULE_VERSION=5.68
inherit perl-module

DESCRIPTION='Implements default import method for modules'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
RDEPEND=""

SRC_TEST="do"
