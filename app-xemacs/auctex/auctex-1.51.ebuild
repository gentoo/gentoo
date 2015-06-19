# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/auctex/auctex-1.51.ebuild,v 1.7 2014/08/10 18:42:28 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Basic TeX/LaTeX support"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/texinfo
app-xemacs/fsf-compat
app-xemacs/mail-lib
app-xemacs/edit-utils
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
