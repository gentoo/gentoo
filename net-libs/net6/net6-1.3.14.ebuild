# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/net6/net6-1.3.14.ebuild,v 1.7 2014/06/22 18:43:03 maekke Exp $

EAPI=4

inherit multilib

DESCRIPTION="Network access framework for IPv4/IPv6 written in C++"
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc x86"
IUSE="nls static-libs"

RDEPEND="dev-libs/libsigc++:2
	>=net-libs/gnutls-1.2.10"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf $(use_enable nls) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || rm -f "${D}"/usr/$(get_libdir)/lib${PN}.la
}

pkg_postinst() {
	elog "Please note that because of the use of C++ templates"
	elog "Gobby 0.4 has to be recompiled against the new ${PN}"
	elog "to pick up the changes."
}
