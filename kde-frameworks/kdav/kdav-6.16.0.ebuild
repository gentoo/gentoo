# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="DAV protocol implemention with KJobs"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=kde-frameworks/kcoreaddons-${KDE_CATV}:6
	>=kde-frameworks/ki18n-${KDE_CATV}:6
	>=kde-frameworks/kio-${KDE_CATV}:6
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# bug 616808: requires D-Bus
	kdav-davitemfetchjob
	# bug 653602: mimetypes unsupported
	kdav-davitemslistjob
	# bug 765061
	kdav-davcollectionsmultifetchjobtest
)
