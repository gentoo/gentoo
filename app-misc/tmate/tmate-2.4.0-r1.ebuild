# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Instant terminal sharing"
HOMEPAGE="https://tmate.io/"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="debug"

SRC_URI="https://github.com/tmate-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="
	sys-libs/zlib
	sys-libs/libutempter
	dev-libs/libevent
	dev-libs/msgpack
	>=net-libs/libssh-0.6.0
	dev-libs/openssl:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		--disable-static
	)
	econf "${myeconfargs[@]}"
}
