# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for searching and managing metadata"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # bug 624250

DEPEND="
	>=dev-db/lmdb-0.9.17
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kcrash-${KDE_CATV}*:6
	=kde-frameworks/kdbusaddons-${KDE_CATV}*:6
	=kde-frameworks/kfilemetadata-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kidletime-${KDE_CATV}*:6
	=kde-frameworks/kio-${KDE_CATV}*:6
	=kde-frameworks/solid-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
