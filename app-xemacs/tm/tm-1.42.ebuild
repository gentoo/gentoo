# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="Emacs MIME support. Not needed for gnus >= 5.8.0"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/gnus
app-xemacs/mh-e
app-xemacs/rmail
app-xemacs/vm
app-xemacs/mailcrypt
app-xemacs/mail-lib
app-xemacs/apel
app-xemacs/xemacs-base
app-xemacs/fsf-compat
app-xemacs/sh-script
app-xemacs/net-utils
app-xemacs/ecrypto
"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

inherit xemacs-packages
