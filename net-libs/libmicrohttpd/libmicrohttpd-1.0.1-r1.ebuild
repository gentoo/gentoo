# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-info multilib-minimal verify-sig

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz
	verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig )"
S="${WORKDIR}"/${MY_P}

LICENSE="|| ( LGPL-2.1+ !ssl? ( GPL-2+-with-eCos-exception-2 ) )"
SLOT="0/12"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug +epoll +eventfd ssl static-libs test +thread-names verify-sig"
REQUIRED_USE="epoll? ( kernel_linux )"
RESTRICT="!test? ( test )"

KEYRING_VER=201906

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20:=[${MULTILIB_USEDEP}] )"
# libcurl and the curl binary are used during tests on CHOST
DEPEND="${RDEPEND}
	test? ( net-misc/curl[ssl?] )"
BDEPEND="ssl? ( virtual/pkgconfig )
	verify-sig? ( ~sec-keys/openpgp-keys-libmicrohttpd-${KEYRING_VER} )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libmicrohttpd-${KEYRING_VER}.asc

DOCS=( AUTHORS NEWS COPYING README ChangeLog )

# All checks in libmicrohttpd's configure are correct
# Gentoo Bug #923760
QA_CONFIG_IMPL_DECL_SKIP=(
	'stpncpy'
)

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
	if use eventfd; then
		itc_type="eventfd"
	else
		itc_type="pipe"
	fi
	ECONF_SOURCE="${S}" \
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--enable-bauth \
		--enable-dauth \
		--enable-messages \
		--enable-postprocessor \
		--enable-httpupgrade \
		--disable-examples \
		--disable-tools \
		--disable-experimental \
		--disable-heavy-tests \
		--enable-itc=${itc_type} \
		$(use_enable debug asserts) \
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
