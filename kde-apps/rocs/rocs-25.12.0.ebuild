# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Interface to work with Graph Theory"
HOMEPAGE="https://apps.kde.org/rocs/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.49
"
