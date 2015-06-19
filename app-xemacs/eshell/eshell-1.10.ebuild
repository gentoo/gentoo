# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/eshell/eshell-1.10.ebuild,v 1.3 2007/06/03 18:21:09 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Command shell implemented entirely in Emacs Lisp"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xemacs-eterm
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
