# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit multilib-minimal

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1+"
SLOT="0/12"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+epoll ssl static-libs test +thread-names"
RESTRICT="!test? ( test )"

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20:=[${MULTILIB_USEDEP}] )"
# libcurl and the curl binary are used during tests on CHOST
DEPEND="${RDEPEND}
	test? ( net-misc/curl[ssl?] )"
BDEPEND="ssl? ( virtual/pkgconfig )"

DOCS=( AUTHORS NEWS COPYING README ChangeLog )

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--disable-nls \
		--enable-bauth \
		--enable-dauth \
		--disable-examples \
		--enable-messages \
		--enable-postprocessor \
		--enable-httpupgrade \
		--disable-experimental \
		--disable-heavy-tests \
		$(use_enable thread-names) \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_enable ssl https) \
		$(use_with ssl gnutls)
}

multilib_src_install_all() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
