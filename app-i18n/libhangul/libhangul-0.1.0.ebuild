# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/libhangul/libhangul-0.1.0.ebuild,v 1.8 2015/05/01 05:33:20 jer Exp $

EAPI=4

DESCRIPTION="libhangul is a generalized and portable library for processing hangul"
HOMEPAGE="http://code.google.com/p/libhangul/"
SRC_URI="http://libhangul.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE="nls static-libs test"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-libs/check )"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/libhangul.la
}
