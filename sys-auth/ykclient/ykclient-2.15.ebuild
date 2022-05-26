# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Yubico C client library"
SRC_URI="http://opensource.yubico.com/yubico-c-client/releases/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubico-c-client"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests require an active network connection, we don't want to run them
RESTRICT="test"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
