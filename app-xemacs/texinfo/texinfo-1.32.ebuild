# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="XEmacs TeXinfo support"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/text-modes
app-xemacs/xemacs-base
"
KEYWORDS="~alpha amd64 hppa ppc ppc64 sparc x86"

inherit xemacs-packages
