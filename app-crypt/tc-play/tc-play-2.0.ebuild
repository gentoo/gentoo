# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/tc-play/tc-play-2.0.ebuild,v 1.2 2015/06/05 12:09:50 jlec Exp $

EAPI=5

inherit toolchain-funcs multilib

DESCRIPTION="a free, pretty much fully featured and stable TrueCrypt implementation"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openssl"

DEPEND="
	dev-libs/libgpg-error
	sys-fs/lvm2
	sys-apps/util-linux
	dev-libs/libgcrypt:0
	openssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	local backend="gcrypt"
	use openssl && backend="openssl"

	EXTRA_MAKE_FLAGS=(
		PBKDF_BACKEND="${backend}"
		WARNFLAGS=""
		CC=$(tc-getCC)
		AR=$(tc-getAR)
		PREFIX=/usr \
		LIBDIR=/usr/$(get_libdir)
	)
}

src_compile() {
	emake -f Makefile.classic \
		tcplay \
		"${EXTRA_MAKE_FLAGS[@]}"
}

src_install() {
	emake -f Makefile.classic \
		"${EXTRA_MAKE_FLAGS[@]}" \
		install_program \
		DESTDIR="${ED}"
	dodoc README.md
}
