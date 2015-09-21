# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIKER
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Very fast base to base conversion"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do parallel"
