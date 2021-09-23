# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm

DESCRIPTION="KJob based DAV protocol implementation"
HOMEPAGE="https://api.kde.org/kdepim/kdav2/html/"
SRC_URI="https://github.com/KDE/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# disable tests requiring net access, bug #680952
	local myctestargs=(
		-E "(kdav2-davcollectionfetchjob|kdav2-davcollectioncreatejob)"
	)

	ecm_src_test
}
