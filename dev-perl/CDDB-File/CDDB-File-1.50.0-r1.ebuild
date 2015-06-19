# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB-File/CDDB-File-1.50.0-r1.ebuild,v 1.1 2014/08/22 17:36:49 axs Exp $

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.05
inherit perl-module

DESCRIPTION="Parse a CDDB/freedb data file"

LICENSE="|| ( GPL-3 GPL-2 )" # GPL-2+
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc x86"
IUSE=""

SRC_TEST="do"
