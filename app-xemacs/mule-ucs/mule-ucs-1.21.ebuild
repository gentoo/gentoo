# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="MULE: Extended coding systems (including Unicode) for XEmacs"
XEMACS_PKG_CAT="mule"

RDEPEND="app-xemacs/mule-base
app-xemacs/latin-euro-standards
"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"

inherit xemacs-packages
