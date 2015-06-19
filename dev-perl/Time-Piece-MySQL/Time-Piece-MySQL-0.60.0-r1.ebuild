# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Piece-MySQL/Time-Piece-MySQL-0.60.0-r1.ebuild,v 1.1 2014/08/26 17:11:42 axs Exp $

EAPI=5

MODULE_AUTHOR=KASEI
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="MySQL-specific functions for Time::Piece"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/perl-Time-Piece-1.15"
DEPEND="${RDEPEND}"

SRC_TEST=do
