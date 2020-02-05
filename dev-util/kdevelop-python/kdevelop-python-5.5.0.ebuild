# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KDE_ORG_NAME="kdev-python"
PYTHON_COMPAT=( python3_{6,7,8} )
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org python-single-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python plugin for KDevelop"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-util/kdevelop:5=
"
RDEPEND="${DEPEND}
	dev-python/pycodestyle[${PYTHON_USEDEP}]
"

RESTRICT+=" test"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}
