# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_QTHELP="false"
KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework providing plugins to use KDE frameworks widgets in QtDesigner"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
"
RDEPEND="${DEPEND}"
