# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Emacs source code browser"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/semantic
app-xemacs/eieio
app-xemacs/fsf-compat
app-xemacs/edit-utils
app-xemacs/jde
app-xemacs/mail-lib
app-xemacs/eshell
app-xemacs/ediff
app-xemacs/xemacs-devel
app-xemacs/speedbar
app-xemacs/c-support
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
