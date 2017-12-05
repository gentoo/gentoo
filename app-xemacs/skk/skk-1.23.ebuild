# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SLOT="0"
DESCRIPTION="MULE: Japanese Language Input Method"
XEMACS_PKG_CAT="mule"

DEPEND="app-xemacs/viper
app-xemacs/mule-base
app-xemacs/elib
app-xemacs/xemacs-base
app-xemacs/apel
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
