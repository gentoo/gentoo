# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/pcomplete/pcomplete-1.06.ebuild,v 1.7 2014/08/10 19:21:36 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Provides programmatic completion"
PKG_CAT="standard"

RDEPEND="app-xemacs/sh-script
app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
