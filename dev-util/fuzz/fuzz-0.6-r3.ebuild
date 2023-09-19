# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Stress-tests programs by giving them random input"
HOMEPAGE="http://fuzz.sourceforge.net/"
DEB_P="${PN}_${PV}"
DEB_PR="7.3"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}-${DEB_PR}.diff.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}"

PATCHES=( "${WORKDIR}"/${DEB_P}-${DEB_PR}.diff )

src_prepare() {
	default
	tc-export CC
	# Clang 16, bug #898764
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README ChangeLog AUTHORS
}
