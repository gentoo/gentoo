# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="DAV protocol implemention with KJobs"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kio-${PVCUT}:5
"
DEPEND="${RDEPEND}"

src_test() {
	# bug 616808 - DavItemFetchJobTest requires D-Bus
	# bug 653602 - DavItemsListJobTest mimetypes unsupported
	# bug 765061 - kdav-davcollectionsmultifetchjobtest
	local myctestargs=(
		-E "(kdav-davitemfetchjob|kdav-davitemslistjob|kdav-davcollectionsmultifetchjobtest)"
	)
	ecm_src_test
}
