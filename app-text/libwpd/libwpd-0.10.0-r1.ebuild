# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libwpd/libwpd-0.10.0-r1.ebuild,v 1.3 2015/02/15 14:58:49 ago Exp $

EAPI=5

inherit alternatives eutils

DESCRIPTION="WordPerfect Document import/export library"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0.10"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips x86 ~x86-fbsd"
IUSE="doc test +tools"

RDEPEND="dev-libs/librevenge"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"
RDEPEND="${RDEPEND}
	!<app-text/libwpd-0.8.14-r1"

src_configure() {
	econf \
		--disable-static \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable tools) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--program-suffix=-${SLOT}
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_postinst() {
	if use tools; then
		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-10]"
		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-10]"
		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-10]"
	fi
}

pkg_postrm() {
	if use tools; then
		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-10]"
		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-10]"
		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-10]"
	fi
}
