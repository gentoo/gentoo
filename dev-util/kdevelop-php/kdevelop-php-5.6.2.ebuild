# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KDE_ORG_NAME="kdev-php"
KFMIN=5.77.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="PHP plugin for KDevelop"
HOMEPAGE="https://kdevelop.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="5"
IUSE=""

# remaining tests fail for some, bug 668530
RESTRICT+=" test"

BDEPEND="
	test? ( dev-util/kdevelop:5[test] )
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-util/kdevelop-pg-qt:5
	dev-util/kdevelop:5=
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# tests hang, bug 667922
	local myctestargs=(
		-E "(completionbenchmark|duchain_multiplefiles)"
	)
	ecm_src_test
}
