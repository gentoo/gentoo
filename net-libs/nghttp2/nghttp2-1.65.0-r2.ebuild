# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Built with autotools rather than cmake to avoid circular dep (bug #951525)

inherit multilib-minimal

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/nghttp2/nghttp2.git"
	inherit git-r3
else
	inherit autotools
	SRC_URI="https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="MIT"
SLOT="0/1.14" # 1.<SONAME>
IUSE="debug hpack-tools jemalloc systemd test utils xml"
RESTRICT="!test? ( test )"

RDEPEND="
	hpack-tools? ( >=dev-libs/jansson-2.5:= )
	jemalloc? ( dev-libs/jemalloc:=[${MULTILIB_USEDEP}] )
	utils? (
		>=dev-libs/openssl-1.0.2:0=[-bindist(-),${MULTILIB_USEDEP}]
		>=dev-libs/libev-4.15[${MULTILIB_USEDEP}]
		net-dns/c-ares:=[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
	)
	systemd? ( >=sys-apps/systemd-209 )
	xml? ( >=dev-libs/libxml2-2.7.7:2=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc16.patch
)

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

multilib_src_configure() {
	# TODO: enable HTTP3
	# requires quictls/openssl, libngtcp2, libngtcp2_crypto_quictls, libnghttp3
	local myeconfargs=(
		--disable-examples
		--disable-failmalloc
		--disable-werror
		--enable-threads
		$(use_enable debug)
		$(multilib_native_use_enable hpack-tools)
		$(multilib_native_use_with hpack-tools jansson)
		$(multilib_native_use_with jemalloc)
		$(multilib_native_use_with systemd)
		$(multilib_native_use_enable utils app)
		$(multilib_native_use_with xml libxml2)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}"/usr -type f -name '*.la' -delete || die
}
