# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Integrated Development Environment for Java"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/cc-mode
app-xemacs/semantic
app-xemacs/debug
app-xemacs/speedbar
app-xemacs/edit-utils
app-xemacs/xemacs-eterm
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/elib
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/os-utils
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
