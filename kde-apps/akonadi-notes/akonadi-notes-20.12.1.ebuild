# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="Library for akonadi notes integration"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}"
