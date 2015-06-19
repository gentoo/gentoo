# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/socket++/socket++-1.12.12-r1.ebuild,v 1.10 2013/09/07 08:35:52 pacho Exp $

inherit autotools eutils

DESCRIPTION="C++ Socket Library"
HOMEPAGE="http://www.linuxhacker.at/socketxx/"
SRC_URI="http://www.linuxhacker.at/linux/downloads/src/${P}.tar.gz"

LICENSE="freedist GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~mips x86"
IUSE="debug doc"
RESTRICT="bindist"

DEPEND="sys-devel/libtool
	sys-apps/texinfo"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc47.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	emake || die "emake failed"

	if use doc ; then
		cd "${S}"/doc
		einfo "Building HTML documentation"
		# the 'html' target in both ${S}/Makefile and ${S}/doc/Makefile
		# do indeed exist (and succeed when run manually), but fail when
		# 'make html' is done here, so we call makeinfo ourselves.
		makeinfo --html -I . -o html socket++.texi || die "makeinfo failed"
	fi
}

src_test() {
	cd "${S}"/test
	make check || die "make check failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README* THANKS || die "dodoc failed"

	insinto /usr/lib/pkgconfig
	doins "${FILESDIR}"/${PN}.pc || die "failed to install pkgconfig script"
	dosed "s/PV/${PV}/" /usr/lib/pkgconfig/${PN}.pc || die "sed failed"

	if use doc ; then
		dohtml doc/html/* || die "dohtml failed"
	fi
}
