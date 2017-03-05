# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/oroborus-//}

DESCRIPTION="utility for binding keys in Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/k/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	!x11-wm/oroborus-extras"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

DOCS=( README docs/example_rc debian/changelog )

src_prepare() {
	default
	sed -e "s: -g -O2 -Wall::" \
		-e "/^install:/s/install-docs//" \
		-i Makefile.in || die
}

src_compile() {
	emake VERBOSE=1
}
