# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/latin-euro-standards/latin-euro-standards-1.09.ebuild,v 1.7 2014/08/10 19:09:41 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Support for the Latin{7,8,9,10} character sets & coding systems"
PKG_CAT="mule"

RDEPEND="app-xemacs/mule-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
