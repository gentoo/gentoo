# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/FCGI-ProcManager/FCGI-ProcManager-0.250.0.ebuild,v 1.1 2015/05/18 21:04:31 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ARODLAND
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="A FastCGI process manager"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
