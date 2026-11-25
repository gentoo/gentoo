# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
inherit ecm frameworks.kde.org

DESCRIPTION="Library for handling mail messages and newsgroup articles"

LICENSE="LGPL-2 LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="=kde-frameworks/kcodecs-${KDE_CATV}*:6"
RDEPEND="${DEPEND}
	!<kde-apps/kmime-26.04.1-r1:*
	!=kde-apps/kmime-26.04.2-r0
	!kde-apps/kmime-common
"
BDEPEND="dev-qt/qttools:6[linguist]"

CMAKE_SKIP_TESTS=(
	# bug 924507
	kmime-{header,message}test
)
