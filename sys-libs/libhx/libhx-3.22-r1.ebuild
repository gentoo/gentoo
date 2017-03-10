# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Platform independent library providing basic system functions"
HOMEPAGE="http://libhx.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/libHX-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S="${WORKDIR}/libHX-${PV}"

PATCHES=( "${FILESDIR}/${P}-no-lyx.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	if use doc; then
		dodoc doc/*.txt
	else
		dodoc doc/changelog.txt
		rm "${D}/usr/share/doc/${PF}/"*.pdf || die
	fi

	prune_libtool_files --all
}
