# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/common-sense/common-sense-3.730.0.ebuild,v 1.1 2015/05/01 19:52:22 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=3.73
inherit perl-module

DESCRIPTION="common::sense - save a tree AND a kitten, use common::sense!"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-solaris"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST=do
