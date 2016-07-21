# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Shared library to impliment the scrypt algorithm.  See http://www.tarsnap.com/scrypt.html."
HOMEPAGE="https://github.com/technion/libscrypt"
SRC_URI="https://github.com/technion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	export PREFIX=/usr
	export LIBDIR=${PREFIX}/$(get_libdir)
	export CC=$(tc-getCC)
	export CFLAGS="$CFLAGS -fPIC"
	export LDFLAGS="$LDFLAGS -Wl,-soname,libscrypt.so.0 -Wl,--version-script=libscrypt.version"
	export CFLAGS_EXTRA=
	emake
}
