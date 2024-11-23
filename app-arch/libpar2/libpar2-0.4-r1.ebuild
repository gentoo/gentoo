# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="A library for par2, extracted from par2cmdline"
HOMEPAGE="https://launchpad.net/libpar2/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-libs/libsigc++:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	elibtoolize

	# broken distfile, see https://bugs.gentoo.org/939532
	touch config.h.in || die
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
