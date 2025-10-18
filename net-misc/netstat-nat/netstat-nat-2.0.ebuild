# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}-ng"
MY_PV="2a"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Display NAT connections"
HOMEPAGE="https://git.sr.ht/~nabijaczleweli/netstat-nat-ng"
SRC_URI="https://git.sr.ht/~nabijaczleweli/netstat-nat-ng/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"

src_compile() {
	emake all
}

src_test() {
	emake check
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}/" install

	einstalldocs
	local DOCS=( README )
}
