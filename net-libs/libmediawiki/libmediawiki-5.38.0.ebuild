# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm kde.org

DESCRIPTION="C++ interface for MediaWiki based web service as wikipedia.org"
HOMEPAGE="https://invent.kde.org/libraries/libmediawiki"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RESTRICT="test"

DEPEND="
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-5.37.0-tests-optional.patch" )

src_test() {
	# bug 646808, 662592
	local myctestargs=(
		-j1
		-E "(libmediawiki-logintest|libmediawiki-logouttest|libmediawiki-queryimageinfotest|libmediawiki-queryimagestest|libmediawiki-queryinfotest|libmediawiki-querysiteinfousergroupstest)"
	)
	ecm_src_test
}
