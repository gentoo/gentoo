# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Library for akonadi contact integration"

LICENSE="GPL-2+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 arm64"
IUSE=""

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT="test"

RDEPEND="
	>=dev-libs/ktextaddons-1.8.0:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/grantleetheme-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6
"
DEPEND="${RDEPEND}"
