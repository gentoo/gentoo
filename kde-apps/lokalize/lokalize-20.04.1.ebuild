# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
PYTHON_COMPAT=( python3_{6,7,8} )
KFMIN=5.70.0
QTMIN=5.12.3
inherit python-single-r1 ecm kde.org

DESCRIPTION="KDE Applications 5 translation tool"
HOMEPAGE="https://kde.org/applications/office/org.kde.lokalize
https://l10n.kde.org/tools/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=app-text/hunspell-1.2.8:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kross-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/translate-toolkit[${PYTHON_MULTI_USEDEP}]
	')
	>=kde-apps/kross-interpreters-${PV}:${SLOT}[python]
"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_install() {
	ecm_src_install
	python_fix_shebang "${ED}/usr/share/${PN}"
}

pkg_postinst() {
	ecm_pkg_postinst

	has_version dev-vcs/subversion || \
		elog "To be able to autofetch KDE translations in new project wizard, install dev-vcs/subversion."
}
