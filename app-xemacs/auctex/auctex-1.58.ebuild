# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Basic TeX/LaTeX support"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/texinfo
app-xemacs/fsf-compat
app-xemacs/mail-lib
app-xemacs/edit-utils
app-xemacs/xemacs-ispell
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
