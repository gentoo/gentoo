# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="Hyperbole: The Everyday Info Manager"
XEMACS_PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/calendar
app-xemacs/vm
app-xemacs/text-modes
app-xemacs/gnus
app-xemacs/mh-e
app-xemacs/rmail
app-xemacs/apel
app-xemacs/tm
app-xemacs/sh-script
app-xemacs/net-utils
"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
