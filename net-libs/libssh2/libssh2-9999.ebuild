# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true
EGIT_REPO_URI="https://github.com/libssh2/libssh2"
inherit autotools-multilib git-r3

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="http://www.libssh2.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="gcrypt libressl static-libs test zlib"

DEPEND="
	!gcrypt? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS=( README )

PATCHES=( "${FILESDIR}"/${PN}-1.8.0-libgcrypt-prefix.patch )

src_prepare() {
	sed -i -e 's|mansyntax.sh||g' tests/Makefile.am || die
	ln -s ../src/libssh2_config.h.in example/libssh2_config.h.in || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	# Disable tests that require extra permissions (bug #333319)
	use test && local -x ac_cv_path_SSHD=

	local myeconfargs=(
		$(use_with zlib libz)
		$(usex gcrypt --with-libgcrypt --with-openssl)
	)
	autotools-utils_src_configure
}
