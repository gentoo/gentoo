# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Utilities for the maintainance of the IBM and Apple PowerPC platforms"
HOMEPAGE="https://github.com/ibm-power-utilities/powerpc-utils"
SRC_URI="https://github.com/ibm-power-utilities/${PN//ibm-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="+rtas"

S="${WORKDIR}/${P//ibm-}"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="ppc ppc64"

RDEPEND="
	!<sys-apps/powerpc-utils-1.1.3.18-r4
	rtas? ( >=sys-libs/librtas-2.0.2 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.5-docdir.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_with rtas librtas)
}
