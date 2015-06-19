# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libixp/libixp-0.5_p20110208-r3.ebuild,v 1.2 2013/04/09 13:22:45 naota Exp $

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
	# http://code.google.com/p/libixp/issues/detail?id=2
	sed -i -e 's:ixp_serve9pconn:ixp_serve9conn:' include/ixp.h || die

	# http://bugs.gentoo.org/393299 http://code.google.com/p/wmii/issues/detail?id=247
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
