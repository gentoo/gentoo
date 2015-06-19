# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MIME-Base32/MIME-Base32-1.20.0.ebuild,v 1.1 2014/11/08 01:20:10 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DANPEDER
MODULE_VERSION=1.02a
inherit perl-module

DESCRIPTION="Base32 encoder / decoder"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
RDEPEND=""

S="${WORKDIR}/${PN}-1.02"
