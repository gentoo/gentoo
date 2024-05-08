# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://api.kde.org/kdepim/libkgapi/html/index.html"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/cyrus-sasl:2
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_test() {
	local myctestargs=(
		# Both fail for multiple distros, see bug #832709 for more discussion
		# Revisit at least once Qt 5.15.3 is in wider distribution (in Gentoo at least):
		#   contacts-contactcreatejobtest, contacts-contactmodifyjobtest
		# More failures not specific to Gentoo, bug #852593, KDE-bug #440648:
		#  calendar-eventcreatejobtest, calendar-eventfetchjobtest, calendar-eventmodifyjobtest
		-E "(contacts-contactcreatejobtest|contacts-contactmodifyjobtest|calendar-eventcreatejobtest|calendar-eventfetchjobtest|calendar-eventmodifyjobtest)"
	)

	ecm_src_test
}
