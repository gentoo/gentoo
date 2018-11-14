# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
inherit eutils toolchain-funcs multilib

DESCRIPTION="An alternative protocol to UPnP IGD specification"
HOMEPAGE="http://miniupnp.free.fr/libnatpmp.html"
SRC_URI="http://miniupnp.free.fr/files/download.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/respect-FLAGS-${PV}.patch
	epatch "${FILESDIR}"/respect-libdir-20120821.patch
	use static-libs || epatch "${FILESDIR}"/remove-static-lib-${PV}.patch
	tc-export CC
}

src_install() {
	emake PREFIX="${D}" GENTOO_LIBDIR="$(get_libdir)" install

	dodoc Changelog.txt README
	doman natpmpc.1
}
