# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Basic Mule support, required for building with Mule"
PKG_CAT="mule"

RDEPEND="app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/apel
"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"

inherit xemacs-packages
