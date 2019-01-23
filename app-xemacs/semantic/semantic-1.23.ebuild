# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Semantic bovinator (Yacc/Lex for XEmacs). Includes Senator"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/ede
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edit-utils
app-xemacs/speedbar
app-xemacs/texinfo
app-xemacs/fsf-compat
app-xemacs/cc-mode
app-xemacs/edebug
app-xemacs/sgml
"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86"

inherit xemacs-packages
