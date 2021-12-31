# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="XSL editing support"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-ispell
app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
