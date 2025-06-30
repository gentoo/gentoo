# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KDE_ORG_NAME="kdev-php"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="PHP plugin for KDevelop"
HOMEPAGE="https://kdevelop.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="6"
KEYWORDS="amd64 arm64"
IUSE=""

# remaining tests fail for some, bug 668530
RESTRICT="test"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	dev-util/kdevelop:6=
	>=dev-util/kdevelop-pg-qt-2.3.0:0
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/kdevelop:6[test] )"

src_test() {
	# tests hang, bug 667922
	local myctestargs=(
		-E "(completionbenchmark|duchain_multiplefiles)"
	)
	ecm_src_test
}
