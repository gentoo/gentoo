# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Emacs Lisp developer support"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xemacs-ispell
app-xemacs/mail-lib
app-xemacs/gnus
app-xemacs/rmail
app-xemacs/tm
app-xemacs/apel
app-xemacs/sh-script
app-xemacs/net-utils
app-xemacs/xemacs-eterm
app-xemacs/ecrypto
"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"

inherit xemacs-packages
