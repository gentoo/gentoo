# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KDE_ORG_CATEGORY="pim"
PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Libraries for messaging functions"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # bug 926482, needs gpg-agent

DEPEND="
	dev-cpp/gpgmepp:=
	dev-libs/qgpgme:=
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/kmbox-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-apps/libkleo-${PVCUT}:6=
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}"
