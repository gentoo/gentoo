# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A cross-platform C library for decoding .smk Smacker Video files."
HOMEPAGE="http://libsmacker.sourceforge.net"
SRC_URI="https://sourceforge.net/projects/libsmacker/files/libsmacker-$(ver_cut 1-2)/${P/_p/r}.tar.gz/download -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	# No .la files or static libraries
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
