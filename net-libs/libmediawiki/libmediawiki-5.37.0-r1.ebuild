# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="C++ interface for MediaWiki based web service as wikipedia.org"
HOMEPAGE="https://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-tests-optional.patch"
	"${FILESDIR}/${P}-fix-warnings.patch"
)

src_test() {
	# bug 646808, 662592
	local myctestargs=(
		-j1
		-E "(libmediawiki-logintest|libmediawiki-logouttest|libmediawiki-queryimageinfotest|libmediawiki-queryimagestest|libmediawiki-queryinfotest|libmediawiki-querysiteinfousergroupstest)"
	)
	ecm_src_test
}
