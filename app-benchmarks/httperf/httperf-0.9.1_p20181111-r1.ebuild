# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="00bf5dab6fd284aa559f125964f5fe6dc0f23595"
inherit autotools

DESCRIPTION="A tool from HP for measuring web server performance"
HOMEPAGE="https://github.com/httperf/httperf"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="amd64 ~mips x86 ~amd64-linux ~x64-macos"
IUSE="debug idleconn"

DEPEND="
	idleconn? ( dev-libs/libevent:0= )
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/usr/bin
		$(use_enable debug)
		$(use_enable idleconn)
	)

	econf "${myeconfargs[@]}"
}
