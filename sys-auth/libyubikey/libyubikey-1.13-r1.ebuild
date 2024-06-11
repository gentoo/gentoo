# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Yubico C low-level library"
HOMEPAGE="https://github.com/Yubico/yubico-c"
SRC_URI="http://opensource.yubico.com/yubico-c/releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

src_prepare() {
	default
	elibtoolize
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
