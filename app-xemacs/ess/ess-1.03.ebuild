# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="ESS: Emacs Speaks Statistics"
XEMACS_PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/edit-utils
app-xemacs/speedbar
app-xemacs/sh-script
app-xemacs/xemacs-eterm
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
