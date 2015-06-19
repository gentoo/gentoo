# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Event/Event-1.240.0.ebuild,v 1.1 2015/05/10 18:33:04 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETJ
MODULE_VERSION=1.24
inherit perl-module

DESCRIPTION="Fast, generic event loop"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do parallel"

mydoc="ANNOUNCE INSTALL TODO Tutorial.pdf"
