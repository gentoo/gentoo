# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.3.3.ebuild,v 1.13 2013/04/25 18:50:00 radhermit Exp $

EAPI=4
inherit autotools

DESCRIPTION="The Ogg Vorbis sound file format library"
HOMEPAGE="http://xiph.org/vorbis"
SRC_URI="http://downloads.xiph.org/releases/vorbis/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="media-libs/libogg"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e '/CFLAGS/s:-O20::' \
		-e '/CFLAGS/s:-mcpu=750::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
