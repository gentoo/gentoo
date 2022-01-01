# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="Library for parsing RSS and Atom feeds"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
"
DEPEND="${COMMON_DEPEND}
	test? (
		>=dev-qt/qtnetwork-${QTMIN}:5
		>=dev-qt/qtwidgets-${QTMIN}:5
	)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/syndication
"
