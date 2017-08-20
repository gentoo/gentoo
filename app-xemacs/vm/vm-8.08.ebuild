# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="An Emacs mailer"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/gnus
app-xemacs/pgg
app-xemacs/ecrypto
app-xemacs/xemacs-eterm
app-xemacs/sh-script
app-xemacs/net-utils
app-xemacs/ps-print
app-xemacs/os-utils
app-xemacs/bbdb
app-xemacs/fsf-compat
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
