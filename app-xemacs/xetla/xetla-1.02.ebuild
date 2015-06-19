# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xetla/xetla-1.02.ebuild,v 1.6 2011/07/22 11:25:06 xarthisius Exp $

SLOT="0"
IUSE=""
DESCRIPTION=" Arch (tla) interface for XEmacs"
PKG_CAT="standard"

RDEPEND="app-xemacs/ediff
app-xemacs/xemacs-base
app-xemacs/jde
app-xemacs/mail-lib
app-xemacs/dired
app-xemacs/prog-modes
"
RDEPEND="app-xemacs/ediff
app-xemacs/xemacs-base
app-xemacs/jde
app-xemacs/mail-lib
app-xemacs/dired
app-xemacs/prog-modes
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
