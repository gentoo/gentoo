# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/supercite/supercite-1.21.ebuild,v 1.5 2014/08/10 19:36:13 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="An Emacs citation tool for News & Mail messages"
PKG_CAT="standard"

RDEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
