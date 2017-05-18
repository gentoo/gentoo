# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ARODLAND
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="A FastCGI process manager"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
