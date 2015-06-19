# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sort-Versions/Sort-Versions-1.500.0-r1.ebuild,v 1.1 2014/08/22 15:56:38 axs Exp $

EAPI=5

MODULE_AUTHOR=EDAVIS
MODULE_VERSION=1.5
inherit perl-module

DESCRIPTION="A perl 5 module for sorting of revision-like numbers"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
