# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Mobile Broadband Interface Model (MBIM) modem protocol helper library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libmbim/ https://gitlab.freedesktop.org/mobile-broadband/libmbim"
SRC_URI="https://www.freedesktop.org/software/libmbim/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~mips ~ppc ~ppc64 x86"
IUSE="udev"

RDEPEND=">=dev-libs/glib-2.48:2
	udev? ( dev-libs/libgudev:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-Werror \
		--disable-static \
		--disable-gtk-doc \
		$(use_with udev)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
