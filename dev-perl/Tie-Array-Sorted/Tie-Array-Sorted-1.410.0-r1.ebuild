# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Array-Sorted/Tie-Array-Sorted-1.410.0-r1.ebuild,v 1.1 2014/08/22 18:26:13 axs Exp $

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.41
inherit perl-module

DESCRIPTION="An array which is kept sorted"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
