# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="C++ interface for MediaWiki based web service as wikipedia.org"
HOMEPAGE="https://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtnetwork)
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
	kde5_src_test
}
