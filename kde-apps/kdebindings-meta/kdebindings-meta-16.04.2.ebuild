# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE bindings - merge this to pull in all kdebindings-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep kross-interpreters)
"
