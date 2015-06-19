# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/python-modes/python-modes-1.14.ebuild,v 1.7 2014/08/10 19:25:15 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Python support"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/edit-utils
app-xemacs/fsf-compat
app-xemacs/text-modes
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
