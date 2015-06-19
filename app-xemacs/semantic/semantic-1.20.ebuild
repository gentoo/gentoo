# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/semantic/semantic-1.20.ebuild,v 1.5 2014/08/10 19:29:31 slyfox Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Semantic bovinator (Yacc/Lex for XEmacs). Includes Senator"
PKG_CAT="standard"

RDEPEND="app-xemacs/eieio
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edit-utils
app-xemacs/speedbar
app-xemacs/texinfo
app-xemacs/fsf-compat
app-xemacs/cc-mode
app-xemacs/edebug
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
