# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/zthread/zthread-2.3.2-r2.ebuild,v 1.2 2012/06/23 11:48:56 xarthisius Exp $

EAPI="4"

inherit eutils autotools

MY_P=ZThread-${PV}
DESCRIPTION="platform-independent multi-threading and synchronization library for C++"
HOMEPAGE="http://zthread.sourceforge.net/"
SRC_URI="mirror://sourceforge/zthread/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug doc kernel_linux static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -f include/zthread/{.Barrier.h.swp,Barrier.h.orig} || die
	epatch "${FILESDIR}"/${P}-no-fpermissive.diff
	epatch "${FILESDIR}"/${P}-m4-quote.patch
	epatch "${FILESDIR}"/${P}-automake.patch
	epatch "${FILESDIR}"/${P}-gcc47.patch

	AT_M4DIR="share" eautoreconf
}

src_configure() {
	local myconf
	# Autoconf does not support --disable-debug properly.
	use debug && myconf="--enable-debug"

	econf \
		$(use_enable kernel_linux atomic-linux) \
		$(use_enable static-libs static) \
		${myconf}
}

src_compile() {
	emake

	if use doc; then
		doxygen doc/zthread.doxygen || die
		cp doc/documentation.html doc/html/index.html || die
		cp doc/zthread.css doc/html/zthread.css || die
		cp doc/bugs.js doc/html/bugs.js || die
	fi
}

src_install() {
	emake install DESTDIR="${ED}"

	dodoc AUTHORS ChangeLog NEWS README TODO
	use doc && dohtml doc/html/*

	use static-libs || find "${ED}" -name '*.la' -delete
}
