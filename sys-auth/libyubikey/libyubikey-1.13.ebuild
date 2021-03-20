# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Yubico C low-level library"
HOMEPAGE="https://github.com/Yubico/yubico-c"
SRC_URI="http://opensource.yubico.com/yubico-c/releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
