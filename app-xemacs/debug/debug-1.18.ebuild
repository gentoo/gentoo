# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/debug/debug-1.18.ebuild,v 1.7 2014/08/10 18:48:30 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="GUD, gdb, dbx debugging support"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd"

inherit xemacs-packages
