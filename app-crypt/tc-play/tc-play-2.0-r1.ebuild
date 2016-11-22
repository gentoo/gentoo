# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib

DESCRIPTION="a free, pretty much fully featured and stable TrueCrypt implementation"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls libressl"

DEPEND="
	dev-libs/libgpg-error
	sys-fs/lvm2
	sys-apps/util-linux
	dev-libs/libgcrypt:0
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
RDEPEND="${DEPEND}"

pkg_setup() {
	local backend="openssl"
	use gnutls && local backend="gcrypt"

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
