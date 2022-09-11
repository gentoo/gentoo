# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.96.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm gear.kde.org

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://api.kde.org/kdepim/libkgapi/html/index.html"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="nls"

DEPEND="
	dev-libs/cyrus-sasl:2
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )"

src_test() {
	local myctestargs=(
		# Both fail for multiple distros, see bug #832709 for more discussion
		# Revisit at least once Qt 5.15.3 is in wider distribution (in Gentoo at least):
		#   contacts-contactcreatejobtest, contacts-contactmodifyjobtest
		# More failures not specific to Gentoo, bug #852593, KDE-bug #440648:
		#  calendar-eventcreatejobtest, calendar-eventfetchjobtest, calendar-eventmodifyjobtest
		-E "(contacts-contactcreatejobtest|contacts-contactmodifyjobtest|calendar-eventcreatejobtest|calendar-eventfetchjobtest|calendar-eventmodifyjobtest)"
	)

	virtx cmake_src_test
}
