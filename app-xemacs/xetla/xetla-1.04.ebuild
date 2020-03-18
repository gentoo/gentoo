# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION=" Arch (tla) interface for XEmacs"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/ediff
app-xemacs/xemacs-base
app-xemacs/jde
app-xemacs/mail-lib
app-xemacs/dired
app-xemacs/prog-modes
"
RDEPEND="app-xemacs/ediff
app-xemacs/xemacs-base
app-xemacs/jde
app-xemacs/mail-lib
app-xemacs/dired
app-xemacs/prog-modes
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
