# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="a backup program for disk array for home media centers"
HOMEPAGE="https://www.snapraid.it/"
SRC_URI="https://github.com/amadvance/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( "AUTHORS" "HISTORY" "README" "TODO" "snapraid.conf.example" )

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	elog "To start using SnapRAID, change the example configuration"
	elog "${EPREFIX}/usr/share/doc/${PF}/snapraid.conf.example.bz2"
	elog "to fit your needs and copy it to ${EPREFIX}/etc/snapraid.conf"
}
