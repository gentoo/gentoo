# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils multilib-minimal

DESCRIPTION="Yubico Universal 2nd Factor (U2F) server C Library"
HOMEPAGE="https://developers.yubico.com/libu2f-server/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	dev-libs/hidapi[${MULTILIB_USEDEP}]
	dev-libs/json-c[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-libs/check[${MULTILIB_USEDEP}]
"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	myeconfargs=(
		--disable-h2a # tarball already contains the manpage
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	prune_libtool_files
}
