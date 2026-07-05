# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false" # TODO: Port to ECMGenerateQDoc
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
	>=dev-cpp/gpgmepp-2:=
	>=dev-libs/qgpgme-2:=
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/kmbox-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-apps/libkleo-${PVCUT}:6=
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}
	dev-libs/kirigami-addons:6
	>=kde-frameworks/kirigami-${KFMIN}:6
"
