# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="virtual/perl-parent"
DEPEND=">=dev-perl/ExtUtils-Depends-0.302
	${RDEPEND}"

SRC_TEST=do
