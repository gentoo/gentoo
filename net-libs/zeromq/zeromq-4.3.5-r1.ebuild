# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="High-performance asynchronous messaging library"
HOMEPAGE="https://zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="doc drafts +libbsd +sodium static-libs test unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	!elibc_Darwin? ( unwind? ( sys-libs/libunwind ) )
	libbsd? ( dev-libs/libbsd:= )
	sodium? ( dev-libs/libsodium:= )
"
DEPEND="
	${RDEPEND}
	!elibc_Darwin? ( sys-apps/util-linux )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.5-c99.patch
)

src_prepare() {
	default

	# Only here for the c99 configure patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-Werror
		--enable-shared
		$(use_enable drafts)
		$(use_enable libbsd)
		$(use_enable static-libs static)
		$(use_enable unwind libunwind)
		$(use_with sodium libsodium)
		$(use_with doc docs)
	)

	# Force bash for configure until the fixes for bug #923922 land in a release
	# https://github.com/zeromq/zproject/pull/1336
	# https://github.com/zeromq/libzmq/pull/4651
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
