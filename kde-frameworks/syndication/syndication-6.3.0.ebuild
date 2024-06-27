# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Library for parsing RSS and Atom feeds"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[xml]
	=kde-frameworks/kcodecs-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[network] )
"
