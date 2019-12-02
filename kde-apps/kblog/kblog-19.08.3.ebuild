# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.60.0
inherit ecm kde.org

DESCRIPTION="Library providing client-side support for web application remote blogging APIs"
LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kxmlrpcclient-${KFMIN}:5
	>=kde-frameworks/syndication-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
