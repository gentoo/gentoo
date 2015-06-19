# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xwem/xwem-1.22.ebuild,v 1.5 2014/08/10 19:50:59 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="X Emacs Window Manager"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xlib
app-xemacs/strokes
app-xemacs/edit-utils
app-xemacs/text-modes
app-xemacs/time
app-xemacs/slider
app-xemacs/elib
app-xemacs/ilisp
app-xemacs/mail-lib
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
