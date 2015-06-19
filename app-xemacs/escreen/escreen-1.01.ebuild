# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/escreen/escreen-1.01.ebuild,v 1.4 2008/04/28 18:02:40 armin76 Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Multiple editing sessions withing a single frame (like screen).."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
