# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Miscellaneous editor extensions, you probably need this"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/fsf-compat
app-xemacs/dired
app-xemacs/mail-lib
"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86"

inherit xemacs-packages
