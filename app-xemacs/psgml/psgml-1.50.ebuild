# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Validated HTML/SGML editing"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/edit-utils
app-xemacs/edebug
app-xemacs/xemacs-devel
app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-eterm
app-xemacs/sh-script
app-xemacs/ps-print
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
