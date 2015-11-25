# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: Add python support.

EAPI="5"

inherit multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/tatsuhiro-t/nghttp2.git"
	inherit git-2
else
	SRC_URI="https://github.com/tatsuhiro-t/nghttp2/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh ~sparc x86"
fi

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"

LICENSE="MIT"
SLOT="0/1.14" # <C++>.<C> SONAMEs
IUSE="cxx debug hpack-tools jemalloc static-libs test +threads utils xml"

RDEPEND="
	cxx? ( dev-libs/boost[${MULTILIB_USEDEP},threads] )
	hpack-tools? ( >=dev-libs/jansson-2.5 )
	jemalloc? ( dev-libs/jemalloc )
	utils? (
		>=dev-libs/libev-4.15
		>=dev-libs/openssl-1.0.2
		>=sys-libs/zlib-1.2.3
	)
	xml? ( >=dev-libs/libxml2-2.7.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-examples \
		--disable-failmalloc \
		--disable-werror \
		--without-cython \
		--disable-python-bindings \
		--without-spdylay \
		$(use_enable cxx asio-lib) \
		$(use_enable debug) \
		$(multilib_native_use_enable hpack-tools) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(multilib_native_use_enable utils app) \
		$(multilib_native_use_with jemalloc) \
		$(multilib_native_use_with xml libxml2)
}

multilib_src_install_all() {
	use static-libs || find "${ED}" -name '*.la' -delete
}
