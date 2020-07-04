# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="A Web browser"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/ecrypto
app-xemacs/gnus
app-xemacs/net-utils
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/xemacs-eterm
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
