# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="X Emacs Window Manager"
XEMACS_PKG_CAT="standard"

XEMACS_EXPERIMENTAL="true"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xlib
app-xemacs/strokes
app-xemacs/edit-utils
app-xemacs/text-modes
app-xemacs/time
app-xemacs/slider
app-xemacs/elib
app-xemacs/ilisp
app-xemacs/mail-lib
app-xemacs/apel
"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

inherit xemacs-packages
