# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libssh2/libssh2-1.5.0.ebuild,v 1.11 2015/07/20 06:10:12 vapier Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true
inherit autotools-multilib

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="http://www.libssh2.org/"
SRC_URI="http://www.${PN}.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="gcrypt static-libs test zlib"

DEPEND="!gcrypt? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS=( README )

PATCHES=( "${FILESDIR}"/${PN}-1.4.2-pkgconfig.patch )

src_prepare() {
	sed -i -e 's|mansyntax.sh||g' tests/Makefile.am || die
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
