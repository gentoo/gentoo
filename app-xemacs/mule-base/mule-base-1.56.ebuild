# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="MULE: Basic Mule support, required for building with Mule"
XEMACS_PKG_CAT="mule"

RDEPEND="app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/apel
"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd"

inherit xemacs-packages
