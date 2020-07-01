# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
inherit ecm kde.org

DESCRIPTION="IDE for the R-project"
HOMEPAGE="https://rkward.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	dev-lang/R
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kdewebkit:5
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
RDEPEND="${DEPEND}
	virtual/libintl
"
