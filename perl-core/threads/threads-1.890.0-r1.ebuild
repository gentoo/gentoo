# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/threads/threads-1.890.0-r1.ebuild,v 1.2 2015/06/13 10:26:50 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JDHEDDEN
MODULE_VERSION=1.89
inherit perl-module

DESCRIPTION="Perl interpreter-based threads"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/perl[ithreads]"
DEPEND="${RDEPEND}"

SRC_TEST=do
