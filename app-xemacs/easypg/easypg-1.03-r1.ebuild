# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/easypg/easypg-1.03-r1.ebuild,v 1.8 2014/08/10 18:50:54 slyfox Exp $

PKG_CAT="standard"

inherit xemacs-packages

SLOT="0"
IUSE=""
DESCRIPTION="GnuPG interface for Emacs"

KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/dired
app-xemacs/mail-lib
"
