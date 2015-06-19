# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libx86/libx86-1.1-r3.ebuild,v 1.3 2013/03/26 11:44:11 ago Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="A hardware-independent library for executing real-mode x86 code"
HOMEPAGE="http://www.codon.org.uk/~mjg59/libx86"
SRC_URI="http://www.codon.org.uk/~mjg59/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

src_prepare() {
	# fix compile failure with linux-headers-2.6.26, bug 235599
	epatch "${FILESDIR}"/${PN}-0.99-ifmask.patch
	# Patch for bugs #236888 and #456648
	epatch "${FILESDIR}"/${P}-makefile.patch

	tc-export CC AR
}

src_compile() {
	local ARGS
	use amd64 && ARGS="BACKEND=x86emu"
	emake ${ARGS} LIBRARY=shared shared
	if use static-libs; then
		emake ${ARGS} objclean
		emake ${ARGS} LIBRARY=static static
	fi
}

src_install() {
	local install_static;
	use static-libs && install_static='install-static'
	emake \
		LIBDIR="/usr/$(get_libdir)" \
		DESTDIR="${D}" \
		install-header install-shared ${install_static}
}
