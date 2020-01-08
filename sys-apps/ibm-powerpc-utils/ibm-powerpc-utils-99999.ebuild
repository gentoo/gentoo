# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="Utilities for the maintainance of the IBM and Apple PowerPC platforms"
HOMEPAGE="https://github.com/ibm-power-utilities/powerpc-utils"
EGIT_REPO_URI="${HOMEPAGE}"
IUSE="+rtas"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS=""

DEPEND="
	sys-devel/bc
"
RDEPEND="
	${DEPEND}
	!sys-apps/powerpc-utils
	rtas? ( >=sys-libs/librtas-2.0.2 )
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.3.5-docdir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with rtas librtas)
}
