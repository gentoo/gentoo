# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Size/Devel-Size-0.790.0-r1.ebuild,v 1.1 2014/08/22 19:10:43 axs Exp $

EAPI=5

MODULE_AUTHOR=NWCLARK
MODULE_VERSION=0.79
inherit perl-module

DESCRIPTION="Perl extension for finding the memory usage of Perl variables"

SLOT="0"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

SRC_TEST="do"
