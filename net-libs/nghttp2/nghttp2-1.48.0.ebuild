# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: Add python support.

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
SRC_URI="https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz
	https://dev.gentoo.org/~voyageur/distfiles/${P}-pthread.patch"

LICENSE="MIT"
SLOT="0/1.14" # <C++>.<C> SONAMEs
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cxx debug hpack-tools jemalloc static-libs test utils xml"

RESTRICT="!test? ( test )"

SSL_DEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist(-),${MULTILIB_USEDEP}]
"
RDEPEND="
	cxx? (
		${SSL_DEPEND}
		dev-libs/boost:=[${MULTILIB_USEDEP}]
	)
	hpack-tools? ( >=dev-libs/jansson-2.5:= )
	jemalloc? ( dev-libs/jemalloc:=[${MULTILIB_USEDEP}] )
	utils? (
		${SSL_DEPEND}
		>=dev-libs/libev-4.15[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
		net-dns/c-ares:=[${MULTILIB_USEDEP}]
	)
	xml? ( >=dev-libs/libxml2-2.7.7:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${DISTDIR}"/${P}-pthread.patch
	)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-examples
		--disable-failmalloc
		--disable-python-bindings
		--disable-werror
		--enable-threads
		--without-cython
		$(use_enable cxx asio-lib)
		$(use_enable debug)
		$(multilib_native_use_enable hpack-tools)
		$(use_enable static-libs static)
		$(use_with test cunit)
		$(multilib_native_use_enable utils app)
		$(multilib_native_use_with jemalloc)
		$(multilib_native_use_with xml libxml2)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}"/usr -type f -name '*.la' -delete || die
	fi
}
