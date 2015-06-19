# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/ksshaskpass/ksshaskpass-5.3.1.ebuild,v 1.1 2015/05/31 22:06:16 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/ksshaskpass"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	dev-qt/qtwidgets:5
"
RDEPEND="
	${DEPEND}
	!net-misc/ksshaskpass
"
