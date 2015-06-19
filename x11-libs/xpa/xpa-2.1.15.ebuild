# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xpa/xpa-2.1.15.ebuild,v 1.2 2015/03/20 14:33:12 jlec Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="Messaging system providing communication between programs"
HOMEPAGE="http://hea-www.harvard.edu/RD/xpa/"
SRC_URI="http://hea-www.harvard.edu/saord/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	dev-lang/tcl:0=
	x11-libs/libXt
	!<sci-astronomy/ds9-5.3"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.8-makefile.patch
	sed -i -e "s:\${LINK}:\${LINK} ${LDFLAGS}:" mklib || die
	eautoconf
}

src_configure() {
	econf \
		--enable-shared \
		--enable-threaded-xpans \
		--with-x \
		--with-tcl \
		--with-threads
}

src_compile() {
	emake shlib tclxpa
}

src_install () {
	dodir /usr/$(get_libdir)
	emake INSTALL_ROOT="${D}" install
	insinto /usr/$(get_libdir)/tclxpa
	doins pkgIndex.tcl
	mv  "${ED}"/usr/$(get_libdir)/libtclxpa* \
		"${ED}"/usr/$(get_libdir)/tclxpa/ || die
	dodoc README
	use doc && dodoc doc/*.pdf && dohtml doc/*.html
	# build system so crappy not worth patching to a non respondant upstream
	# and builds static with PIC
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}
