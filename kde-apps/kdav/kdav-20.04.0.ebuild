# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.69.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="DAV protocol implemention with KJobs"
HOMEPAGE="https://api.kde.org/kdepim/kdav/html/index.html"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# bug 616808 - DavItemFetchJobTest requires D-Bus
	# bug 653602 - DavItemsListJobTest mimetypes unsupported
	local myctestargs=(
		-E "(kdav-davitemfetchjob|kdav-davitemslistjob)"
	)
	ecm_src_test
}
