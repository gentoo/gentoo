# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="https://code.google.com/p/libkate/"
SRC_URI="https://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~sparc x86"

IUSE="debug doc"

RDEPEND="
	media-libs/libogg:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex[${MULTILIB_USEDEP}]
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

multilib_src_configure() {
	local ECONF_SOURCE="${S}"

	econf \
		--disable-static \
		$(use_enable debug) \
		$(multilib_native_use_enable doc) \
		PYTHON=:
}

multilib_src_install_all() {
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
