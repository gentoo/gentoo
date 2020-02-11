# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

XEMACS_PKG_CAT="standard"

inherit xemacs-packages

SLOT="0"
DESCRIPTION="GnuPG interface for Emacs"

KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/dired
app-xemacs/mail-lib
"
