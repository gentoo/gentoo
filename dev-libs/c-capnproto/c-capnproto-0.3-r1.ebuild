# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C library/compiler for the Cap'n Proto serialization/RPC protocol"
HOMEPAGE="https://github.com/opensourcerouting/c-capnproto"
SRC_URI="https://github.com/opensourcerouting/c-capnproto/releases/download/${P}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND="app-arch/xz-utils"

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
