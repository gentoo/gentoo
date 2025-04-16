# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Library to import mail from various sources"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-mime-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
"
RDEPEND="${DEPEND}"
