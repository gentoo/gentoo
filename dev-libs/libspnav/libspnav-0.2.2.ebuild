# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libspnav/libspnav-0.2.2.ebuild,v 1.7 2014/08/10 20:37:53 slyfox Exp $

EAPI="4"

inherit multilib eutils toolchain-funcs

MY_PN='spacenav'
DESCRIPTION="The libspnav provides a replacement of the magellan library with cleaner and more orthogonal API"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${MY_PN}/${MY_PN}%20library%20%28SDK%29/${PN}%20${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="X"

RDEPEND="app-misc/spacenavd[X?]"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-custom-flags.patch
}

src_configure() {
	econf \
		--enable-opt --enable-ldopt \
		$(use_enable X x11)
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	default

	# Use proper libdir
	if [[ $(get_libdir) != lib ]]; then
		mv "${D}"/usr/{lib,$(get_libdir)} || die
	fi

	# Create missing symlinks
	local target=$(basename "${D}"/usr/$(get_libdir)/libspnav.so.*)
	dosym ${target} /usr/$(get_libdir)/libspnav.so.0 || die
	dosym ${target} /usr/$(get_libdir)/libspnav.so || die
}
