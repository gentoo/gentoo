# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="MULE: Quail.  All non-English and non-Japanese language support"
XEMACS_PKG_CAT="mule"

RDEPEND="app-xemacs/mule-base
app-xemacs/fsf-compat
app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
