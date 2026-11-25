# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org xdg

DESCRIPTION="Systemd managment utility"
HOMEPAGE="https://invent.kde.org/system/systemdgenie"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${P}.tar.xz" # at a3ac0f62

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	sys-apps/systemd:=
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	dev-libs/kirigami-addons:6
	>=kde-frameworks/kirigami-${KFMIN}:6
"
BDEPEND="sys-devel/gettext"
