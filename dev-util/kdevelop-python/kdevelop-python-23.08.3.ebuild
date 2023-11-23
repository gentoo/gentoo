# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KDE_ORG_CATEGORY="kdevelop"
KDE_ORG_NAME="kdev-python"
PYTHON_COMPAT=( python3_{10..11} )
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org python-single-r1

DESCRIPTION="Python plugin for KDevelop"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
IUSE=""
KEYWORDS="amd64 arm64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-util/kdevelop:5=
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
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pycodestyle[${PYTHON_USEDEP}]
	')
"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}
