# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libmcpp/libmcpp-2.7.2-r1.ebuild,v 1.7 2012/10/18 08:57:01 ottxor Exp $

EAPI="3"

MY_P=${P/lib/}

DESCRIPTION="A portable C++ preprocessor"
HOMEPAGE="http://mcpp.sourceforge.net"
SRC_URI="mirror://sourceforge/mcpp/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86 ~x64-macos ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--enable-mcpplib \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm -rf "${ED}/usr/share/doc"
	dodoc ChangeLog NEWS README doc/*.pdf
	dohtml doc/*.html

	use static-libs || rm -rf "${ED}"/usr/lib*/*.la
}
