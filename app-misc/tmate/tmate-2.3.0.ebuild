# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Instant terminal sharing"
HOMEPAGE="https://tmate.io/"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libressl static-libs"

SRC_URI="https://github.com/tmate-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="
	sys-libs/zlib[static-libs?]
	sys-libs/libutempter[static-libs?]
	dev-libs/libevent[static-libs?]
	dev-libs/msgpack[static-libs?]
	>=net-libs/libssh-0.6.0[static-libs?]
	!libressl? ( dev-libs/openssl:0=[static-libs?] )
	libressl? ( dev-libs/libressl:0=[static-libs?] )
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
	)
	econf "${myeconfargs[@]}"
}
