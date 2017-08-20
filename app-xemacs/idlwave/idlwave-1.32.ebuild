# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Editing and Shell mode for the Interactive Data Language"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/mail-lib
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
