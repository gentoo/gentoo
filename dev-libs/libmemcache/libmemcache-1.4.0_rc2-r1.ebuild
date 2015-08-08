# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit autotools eutils toolchain-funcs

MY_P=${PN}-${PV/_/.}

DESCRIPTION="C API for memcached"
HOMEPAGE="http://people.freebsd.org/~seanc/libmemcache/"
SRC_URI="http://people.freebsd.org/~seanc/libmemcache/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~sparc-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-inline.patch
	epatch "${FILESDIR}"/${P}-implicit_pointer.patch
	[[ $(tc-arch) == ppc* ]] && epatch "${FILESDIR}"/${P}-ppc_ftbfs.patch

	rm -rf test/unit || die
	sed -i -e '/DIR/s,unit,,g' test/Makefile.am || die
	sed -i \
		-e 's,test/unit/Makefile,,g' \
		-e '/^CFLAGS=.*Wall.*pipe/s,-Wall,${CFLAGS} -Wall,g' \
		-e '/^OPTIMIZE=/d' \
		-e '/^PROFILE=/d' \
		configure.ac || die

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog
}
