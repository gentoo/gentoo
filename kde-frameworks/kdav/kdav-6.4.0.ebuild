# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="DAV protocol implemention with KJobs"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=kde-frameworks/kcoreaddons-${PVCUT}:6
	>=kde-frameworks/ki18n-${PVCUT}:6
	>=kde-frameworks/kio-${PVCUT}:6
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
