# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="DAV protocol implemention with KJobs"
LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="arm64"
IUSE=""

DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

src_test() {
	# bug 616808 - DavItemFetchJobTest requires D-Bus
	# bug 653602 - DavItemsListJobTest mimetypes unsupported
	local myctestargs=(
		-E "(kdav-davitemfetchjob|kdav-davitemslistjob)"
	)
	ecm_src_test
}
