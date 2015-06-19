# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PBS-Client/PBS-Client-0.100.0-r1.ebuild,v 1.1 2014/08/26 15:33:14 axs Exp $

EAPI=5

MODULE_AUTHOR=KWMAK
MODULE_SECTION=PBS/Client
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Perl interface to submit jobs to PBS (Portable Batch System)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
