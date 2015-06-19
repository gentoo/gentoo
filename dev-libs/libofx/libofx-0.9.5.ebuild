# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libofx/libofx-0.9.5.ebuild,v 1.8 2015/06/08 18:14:23 pacho Exp $

EAPI=4

inherit base

DESCRIPTION="A library to support the Open Financial eXchange XML format"
HOMEPAGE="http://libofx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~ppc64 x86"
IUSE="doc static-libs test"

RDEPEND=">=app-text/opensp-1.5
	dev-cpp/libxmlpp:2.6
	>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( sys-apps/help2man )
	test? ( app-crypt/gnupg )"

PATCHES=( "${FILESDIR}/${P}-gcc47.patch" )

src_prepare() {
	base_src_prepare
	# Be sure DTD gets installed in correct path after redefining docdir in install
	sed -i \
		-e 's:$(DESTDIR)$(docdir):$(DESTDIR)$(LIBOFX_DTD_DIR):' \
		dtd/Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-doxygen
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install

	rm -f "${ED}"/usr/share/doc/${PF}/{COPYING,INSTALL}
	find "${ED}" -name '*.la' -exec rm -f {} +
}
