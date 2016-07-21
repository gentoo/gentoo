# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# hg clone http://hg.suckless.org/libixp

EAPI=4
inherit multilib toolchain-funcs

DESCRIPTION="A stand-alone client/server 9P library including ixpc client"
HOMEPAGE="http://libs.suckless.org/libixp"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="app-arch/xz-utils"

pkg_setup() {
	myixpconf=(
		PREFIX="/usr"
		LIBDIR="/usr/$(get_libdir)"
		CC="$(tc-getCC) -c"
		LD="$(tc-getCC) ${LDFLAGS}"
		AR="$(tc-getAR) crs"
		MAKESO="1"
		SOLDFLAGS="-shared"
		)
}

src_prepare() {
	# https://code.google.com/p/libixp/issues/detail?id=2
	sed -i -e 's:ixp_serve9pconn:ixp_serve9conn:' include/ixp.h || die

	# https://bugs.gentoo.org/393299 https://code.google.com/p/wmii/issues/detail?id=247
	sed -i -e '69s:uint32_t:unsigned long:' include/ixp.h || die
}

src_compile() {
	emake "${myixpconf[@]}"
}

src_install() {
	emake "${myixpconf[@]}" DESTDIR="${D}" install
	dolib.so lib/libixp{,_pthread}.so
	dodoc NEWS
}
