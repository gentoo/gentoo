# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit multilib
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc64 ~x86"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="https://cgit.freedesktop.org/libmbim/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="static-libs udev"

RDEPEND=">=dev-libs/glib-2.32:2"
DEPEND="${RDEPEND}
	udev? ( virtual/libgudev )
	dev-util/gtk-doc-am
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-gtk-doc \
		$(use_with udev) \
		$(use_enable static{-libs,})
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
