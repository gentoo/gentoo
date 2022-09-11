# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A rendering library for Kate streams using Pango and Cairo"
HOMEPAGE="https://code.google.com/p/libtiger/"
SRC_URI="https://libtiger.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86"
IUSE="doc"

RDEPEND="
	>=media-libs/libkate-0.2.0[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.4-fix-autoreconf.patch
	"${FILESDIR}"/${PN}-0.3.4-fix-undefined-references-slibtool.patch
)

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	econf \
		--disable-static \
		$(multilib_native_use_enable doc)
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
