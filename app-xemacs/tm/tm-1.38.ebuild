# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/tm/tm-1.38.ebuild,v 1.4 2007/07/11 02:37:37 mr_bones_ Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs MIME support. Not needed for gnus >= 5.8.0"
PKG_CAT="standard"

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
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
