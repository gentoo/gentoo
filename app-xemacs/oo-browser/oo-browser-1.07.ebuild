# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="The Multi-Language Object-Oriented Code Browser"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/hyperbole
app-xemacs/gnus
app-xemacs/sh-script
"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"

inherit xemacs-packages
