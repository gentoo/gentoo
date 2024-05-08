# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Library for akonadi notes integration"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}"
