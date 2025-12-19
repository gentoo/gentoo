# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HTTPERF_COMMIT="de8cd6ad8a79779a0cb74a4aa2175afa9e24df57"
inherit autotools

DESCRIPTION="Tool from HP for measuring web server performance"
HOMEPAGE="https://github.com/httperf/httperf"
SRC_URI="https://github.com/${PN}/${PN}/archive/${HTTPERF_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HTTPERF_COMMIT}"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x64-macos"
IUSE="debug idleconn"

DEPEND="
	dev-libs/openssl:=
	idleconn? ( dev-libs/libevent:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1_p20201206-c23.patch
	"${FILESDIR}"/${PN}-0.9.1_p20201206-memcpy-overlap.patch
)

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
