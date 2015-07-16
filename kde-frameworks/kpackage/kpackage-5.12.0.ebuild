# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kpackage/kpackage-5.12.0.ebuild,v 1.1 2015/07/16 20:33:16 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="Framework to install and load packages of non binary content"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
"
