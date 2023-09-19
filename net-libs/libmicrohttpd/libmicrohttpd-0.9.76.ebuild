# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit multilib-minimal

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="|| ( LGPL-2.1+ !ssl? ( GPL-2+-with-eCos-exception-2 ) )"
SLOT="0/12"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+epoll ssl static-libs test +thread-names"
RESTRICT="!test? ( test )"

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20:=[${MULTILIB_USEDEP}] )"
# libcurl and the curl binary are used during tests on CHOST
DEPEND="${RDEPEND}
	test? ( net-misc/curl[ssl?] )"
BDEPEND="ssl? ( virtual/pkgconfig )"

DOCS=( AUTHORS NEWS COPYING README ChangeLog )

PATCHES=( "${FILESDIR}"/${PN}-0.9.75-fix-testsuite-with-lto.patch )

# All checks in libmicrohttpd's configure are correct
# Gentoo Bug #898662
QA_CONFIG_IMPL_DECL_SKIP=(
	'pthread_sigmask'
	'CreateThread'
	'pthread_attr_init'
	'pthread_attr_setname_np'
	'pthread_setname_np'
	'__builtin_bswap32'
	'__builtin_bswap64'
	'WSAPoll'
	'epoll_create1'
	'eventfd'
	'pipe'
	'pipe2'
	'socketpair'
	'gmtime_s'
	'host_get_clock_service'
	'clock_get_time'
	'mach_port_deallocate'
	'gethrtime'
	'timespec_get'
	'gettimeofday'
	'sendfile'
	'gnutls_privkey_import_x509_raw'
	'calloc'
	'fork'
	'waitpid'
	'random'
	'rand'
	'getsockname'
	'sysconf'
	'sysctl'
	'sysctlbyname'
	'usleep'
	'nanosleep'
)

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
