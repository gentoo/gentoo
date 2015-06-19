# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/B-Hooks-OP-Check/B-Hooks-OP-Check-0.190.0-r1.ebuild,v 1.2 2015/05/01 11:45:33 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-parent"
DEPEND=">=dev-perl/ExtUtils-Depends-0.302
	${RDEPEND}"

SRC_TEST=do
