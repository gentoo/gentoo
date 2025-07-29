# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_PYTHON_BINDINGS="off"
ECM_TEST="false"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for notifying the user of an event"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	media-libs/libcanberra
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
