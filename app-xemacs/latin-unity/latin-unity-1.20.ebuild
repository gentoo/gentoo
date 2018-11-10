# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="MULE: find single ISO 8859 character set to encode a buffer"
XEMACS_PKG_CAT="mule"

RDEPEND="app-xemacs/mule-base
app-xemacs/latin-euro-standards
app-xemacs/mule-ucs
app-xemacs/leim
app-xemacs/fsf-compat
app-xemacs/dired
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
