# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Library implementation for listing vpds"
HOMEPAGE="http://sourceforge.net/projects/linux-diag/"
SRC_URI="http://sourceforge.net/projects/linux-diag/files/libvpd/${PV}/libvpd-${PV}.tar.gz"

LICENSE="IBM"
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
	econf || die "Unable to configure"
}

src_install(){
	emake DESTDIR="${D}" install || die "Something went wrong"

}
