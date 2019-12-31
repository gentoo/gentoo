# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="true"
KDE_ORG_NAME="kdev-php"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="PHP plugin for KDevelop"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="5"
IUSE=""

BDEPEND="
	test? ( dev-util/kdevelop:5[test] )
"
DEPEND="
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
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-util/kdevelop-pg-qt:5
	dev-util/kdevelop:5=
"
RDEPEND="${DEPEND}"

# remaining tests fail for some, bug 668530
RESTRICT+=" test"

src_test() {
	# tests hang, bug 667922
	local myctestargs=(
		-E "(completionbenchmark|duchain_multiplefiles)"
	)
	ecm_src_test
}
