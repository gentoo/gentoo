# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Instant terminal sharing"
HOMEPAGE="https://tmate.io/"
SRC_URI="https://github.com/tmate-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC BSD BSD-2"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/libevent
	dev-libs/msgpack:=
	dev-libs/openssl:=
	>=net-libs/libssh-0.6.0
	sys-libs/zlib
	sys-libs/libutempter
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-msgpack-6.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}
