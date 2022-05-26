# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
inherit ecm kde.org optfeature

DESCRIPTION="IDE for the R-project"
HOMEPAGE="https://rkward.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2+ LGPL-2"
SLOT="5"
IUSE=""

DEPEND="
	dev-lang/R
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/kjobwidgets:5
	kde-frameworks/knotifications:5
	kde-frameworks/kparts:5
	kde-frameworks/kservice:5
	kde-frameworks/ktexteditor:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/kxmlgui:5
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-fix-crash-w-R-4.1.0.patch # KDE-bug 438993
	"${FILESDIR}"/${P}-fix-hang-on-exit.patch # KDE-bug 430680
	"${FILESDIR}"/${P}-fix-dark-themes.patch # KDE-bug 389914
	"${FILESDIR}"/${P}-fix-eop-tag-in-html.patch
	"${FILESDIR}"/${P}-fix-hidpi.patch
)

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "kate plugins support" "kde-apps/kate:${SLOT}"
		optfeature "prendering (or previewing) R markdown (.Rmd) files" "app-text/pandoc"
		optfeature "managing citations while writing articles" "app-text/kbibtex"
	fi
	ecm_pkg_postinst
}
