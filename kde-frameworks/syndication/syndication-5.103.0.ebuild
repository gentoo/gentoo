# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Library for parsing RSS and Atom feeds"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtnetwork-${QTMIN}:5 )
"
