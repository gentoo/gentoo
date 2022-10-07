# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: Add python support.

EAPI=8

inherit autotools git-r3 multilib-minimal

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
EGIT_REPO_URI="https://github.com/nghttp2/nghttp2.git"

LICENSE="MIT"
SLOT="0/1.14" # <C++>.<C> SONAMEs
KEYWORDS=""
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
