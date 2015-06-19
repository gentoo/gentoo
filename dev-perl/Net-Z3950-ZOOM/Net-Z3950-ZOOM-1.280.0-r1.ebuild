# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Z3950-ZOOM/Net-Z3950-ZOOM-1.280.0-r1.ebuild,v 1.1 2014/08/26 19:30:06 axs Exp $

EAPI=5

MODULE_AUTHOR=MIRK
MODULE_VERSION=1.28
inherit perl-module

DESCRIPTION="Perl extension for invoking the ZOOM-C API"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/yaz-2.1.50"
DEPEND="${RDEPEND}"

#SRC_TEST=online
