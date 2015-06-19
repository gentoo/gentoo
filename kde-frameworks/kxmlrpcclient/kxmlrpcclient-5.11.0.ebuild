# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kxmlrpcclient/kxmlrpcclient-5.11.0.ebuild,v 1.1 2015/06/15 18:35:11 kensington Exp $

EAPI=5

KDE_DOXYGEN="true"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Framework providing client-side support for the XML-RPC protocol"
LICENSE="BSD-2"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	dev-qt/qtxml:5
	!<kde-plasma/plasma-workspace-5.2.95
"
DEPEND="${RDEPEND}"
