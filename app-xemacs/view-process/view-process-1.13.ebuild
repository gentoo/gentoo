# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/view-process/view-process-1.13.ebuild,v 1.5 2014/08/10 19:43:01 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="A Unix process browsing tool"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
