# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{10..12} )
KFMIN=5.115.0
QTMIN=5.15.12
inherit python-single-r1 ecm gear.kde.org optfeature

DESCRIPTION="Localization tool for KDE software and other free and open source software"
HOMEPAGE="https://apps.kde.org/lokalize/ https://l10n.kde.org/tools/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test" # tests are broken, bug 739734

DEPEND="${PYTHON_DEPS}
	>=app-text/hunspell-1.2.8:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
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
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/translate-toolkit[${PYTHON_USEDEP}]
	')
"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_install() {
	ecm_src_install
	rm "${ED}"/usr/share/lokalize/scripts/msgmerge.{py,rc} || die
	python_fix_shebang "${ED}"/usr/share/${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "autofetch kde.org translations in new project wizard" dev-vcs/subversion
		optfeature "spell and grammar checking" app-text/languagetool
	fi
	ecm_pkg_postinst
}
