# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit fortran-2

DESCRIPTION="A standalone, drop-in replacement for the CCP4 library"
HOMEPAGE="https://launchpad.net/gpp4/"
SRC_URI="https://launchpad.net/${PN}/1.3/${PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs"

RDEPEND="sci-libs/mmdb:0="
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_with fortran fortran-api) \
		$(use_enable static-libs static)
}
