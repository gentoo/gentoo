# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/os-utils/os-utils-1.39.ebuild,v 1.5 2014/08/10 19:19:44 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Miscellaneous O/S utilities"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
