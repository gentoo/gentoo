# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="YEWENBIN"

inherit perl-module elisp-common

DESCRIPTION="Perl Develop Environment in Emacs"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="virtual/emacs"
DEPEND="dev-perl/Module-Build
		${RDEPEND}"
myconf="--elispdir=${D}${SITELISP}/pde"
