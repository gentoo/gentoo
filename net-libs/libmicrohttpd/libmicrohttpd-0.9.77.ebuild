# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-info multilib-minimal

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="|| ( LGPL-2.1+ !ssl? ( GPL-2+-with-eCos-exception-2 ) )"
SLOT="0/12"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+epoll +eventfd ssl static-libs test +thread-names"
REQUIRED_USE="epoll? ( kernel_linux )"
RESTRICT="!test? ( test )"

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20:=[${MULTILIB_USEDEP}] )"
# libcurl and the curl binary are used during tests on CHOST
DEPEND="${RDEPEND}
	test? ( net-misc/curl[ssl?] )"
BDEPEND="ssl? ( virtual/pkgconfig )"

DOCS=( AUTHORS NEWS COPYING README ChangeLog )

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK=""
		use epoll && CONFIG_CHECK+=" ~EPOLL"
		ERROR_EPOLL="EPOLL is not enabled in kernel, but enabled in libmicrohttpd."
		ERROR_EPOLL+=" libmicrohttpd will fail to start with 'automatic' configuration."
		use eventfd && CONFIG_CHECK+=" ~EVENTFD"
		ERROR_EVENTFD="EVENTFD is not enabled in kernel, but enabled in libmicrohttpd."
		ERROR_EVENTFD+=" libmicrohttpd will not work."
		check_extra_config
	fi
}

multilib_src_configure() {
	local itc_type
	if use eventfd ; then
		itc_type="eventfd"
	else
		itc_type="pipe"
	fi
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
		--enable-itc=${itc_type} \
		$(use_enable thread-names) \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_enable ssl https)
}

multilib_src_install_all() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
