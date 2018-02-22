# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit libtool multilib-minimal

DESCRIPTION="A rendering library for Kate streams using Pango and Cairo"
HOMEPAGE="https://code.google.com/p/libtiger/"
SRC_URI="https://libtiger.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

RDEPEND="x11-libs/pango[${MULTILIB_USEDEP}]
	>=media-libs/libkate-0.2.0[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )"

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	econf \
		--disable-static \
		$(use_enable doc)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
