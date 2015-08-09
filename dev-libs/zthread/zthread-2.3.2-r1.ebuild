# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils autotools

MY_P=ZThread-${PV}

DESCRIPTION="A platform-independent multi-threading and synchronization library for C++"
HOMEPAGE="http://zthread.sourceforge.net/"
SRC_URI="mirror://sourceforge/zthread/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ppc sparc x86"
IUSE="debug doc kernel_linux static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -f include/zthread/{.Barrier.h.swp,Barrier.h.orig} || die
	epatch "${FILESDIR}"/${P}-no-fpermissive.diff

	AT_M4DIR="share" eautoreconf
}

src_configure() {
	local myconf
	use debug && myconf="--enable-debug"

	econf \
		$(use_enable kernel_linux atomic-linux) \
		$(use_enable static-libs static) \
		${myconf}
}

src_compile() {
	emake || die

	if use doc; then
		doxygen doc/zthread.doxygen || die
		cp doc/documentation.html doc/html/index.html || die
		cp doc/zthread.css doc/html/zthread.css || die
		cp doc/bugs.js doc/html/bugs.js || die
	fi
}

src_install() {
	einstall || die

	dodoc AUTHORS ChangeLog NEWS README TODO
	use doc && dohtml doc/html/*

	find "${D}" -name '*.la' -delete
}
