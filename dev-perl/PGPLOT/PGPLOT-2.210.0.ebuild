# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PGPLOT/PGPLOT-2.210.0.ebuild,v 1.6 2014/08/05 17:52:50 zlogene Exp $

EAPI=5

MODULE_AUTHOR=KGB
MODULE_VERSION=2.21
inherit perl-module

DESCRIPTION="allow subroutines in the PGPLOT graphics library to be called from Perl"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# Tests require active X display
#SRC_TEST="do"

RDEPEND="sci-libs/pgplot
	>=dev-perl/ExtUtils-F77-1.13"
DEPEND="${RDEPEND}"
