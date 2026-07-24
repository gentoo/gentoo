# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="DAV protocol implemention with KJobs"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# requires running kde environment, bug #977471
RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=kde-frameworks/kcoreaddons-${KDE_CATV}:6
	>=kde-frameworks/ki18n-${KDE_CATV}:6
	>=kde-frameworks/kio-${KDE_CATV}:6
"
DEPEND="${RDEPEND}"
