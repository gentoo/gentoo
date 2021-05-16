# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Stress-tests programs by giving them random input"
HOMEPAGE="http://fuzz.sourceforge.net/"
DEB_P="${PN}_${PV}"
DEB_PR="7.3"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/readline:0="
RDEPEND="${DEPEND}"

PATCHES=( "${DISTDIR}"/${DEB_P}-${DEB_PR}.diff.gz )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README ChangeLog AUTHORS
}
