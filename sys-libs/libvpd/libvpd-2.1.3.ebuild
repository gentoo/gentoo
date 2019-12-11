# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Library implementation for listing vpds"
HOMEPAGE="https://sourceforge.net/projects/linux-diag/"
SRC_URI="https://sourceforge.net/projects/linux-diag/files/libvpd/${PV}/libvpd-${PV}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc ppc64"
IUSE=""

DEPEND=">=dev-db/sqlite-3.7.8
		sys-libs/zlib"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}

src_configure() {
	./bootstrap.sh
	econf
}

src_install(){
	emake DESTDIR="${D}" install
}
