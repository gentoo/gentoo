# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="New Clearcase Version Control for XEmacs (UNIX, Windows)"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/sh-script
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
