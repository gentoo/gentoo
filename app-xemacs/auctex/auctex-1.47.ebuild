# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/auctex/auctex-1.47.ebuild,v 1.8 2014/08/10 18:42:28 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Basic TeX/LaTeX support"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
