# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool

DESCRIPTION="WavPack audio compression tools"
HOMEPAGE="http://www.wavpack.com"
SRC_URI="http://www.wavpack.com/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cpu_flags_x86_mmx"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable cpu_flags_x86_mmx mmx)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
