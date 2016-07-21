# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Wnn (4.2 and 6) support.  SJ3 support"
PKG_CAT="mule"

RDEPEND="app-xemacs/leim
app-xemacs/mule-base
app-xemacs/fsf-compat
app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
