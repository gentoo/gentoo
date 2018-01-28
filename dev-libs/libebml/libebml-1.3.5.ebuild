# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="https://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="https://dl.matroska.org/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug static-libs"

src_prepare() {
	default
	sed -i '/^AM_CXXFLAGS += -g/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
