# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library for akonadi notes integration"
SLOT="5"
KEYWORDS="amd64 ~arm64 x86"
LICENSE="GPL-2+"
IUSE=""

DEPEND="
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
