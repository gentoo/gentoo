# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpfm/libpfm-4.6.0.ebuild,v 1.1 2015/04/16 04:45:56 slis Exp $

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="Hardware-based performance monitoring interface for Linux"
HOMEPAGE="http://perfmon2.sourceforge.net"
SRC_URI="mirror://sourceforge/perfmon2/${PN}4/${P}.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s:SLDFLAGS=:SLDFLAGS=\$(LDFLAGS) :g" \
		-i lib/Makefile || die
	sed -e "s:LIBDIR=\$(PREFIX)/lib:LIBDIR=\$(PREFIX)/$(get_libdir):g" \
		-i config.mk || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" LDCONFIG=true PREFIX="${EPREFIX}/usr"  install
	use static-libs || find "${ED}" -name '*.a' -exec rm -f '{}' +
	dodoc README
}
