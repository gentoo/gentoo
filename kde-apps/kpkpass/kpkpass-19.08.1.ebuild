# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library to deal with Apple Wallet pass files"
HOMEPAGE="https://kde.org/applications/office/kontact/"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	!<kde-apps/kdepim-addons-18.07.80
"
