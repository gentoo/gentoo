# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal verify-sig

MY_P="${P}-alpha-dev"
DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
BASE_URI="https://github.com/libevent/libevent/releases/download/release-${PV}-alpha"
SRC_URI="
	${BASE_URI}/${MY_P}.tar.gz
	verify-sig? (
		${BASE_URI}/${MY_P}.tar.gz.asc
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0/2.2.1-r2"
KEYWORDS=""
IUSE="
	+clock-gettime debug malloc-replacement mbedtls +ssl static-libs
	test verbose-debug
"
# TODO: hangs
RESTRICT="test"

DEPEND="
	mbedtls? ( net-libs/mbedtls:=[${MULTILIB_USEDEP}] )
	ssl? ( >=dev-libs/openssl-1.0.1h-r2:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	verify-sig? (
		sec-keys/openpgp-keys-libevent
	)
"

DOCS=( README.md ChangeLog{,-1.4,-2.0} whatsnew-2.{0,1}.txt )
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)
VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/libevent.asc

PATCHES=(
	# signalfd-by-default breaks at least app-misc/tmux
	# https://github.com/libevent/libevent/pull/1486
	"${FILESDIR}/${P}-disable-signalfd.patch"
)

multilib_src_configure() {
	# fix out-of-source builds
	mkdir -p test || die

	local ECONF_SOURCE="${S}"
	local myconf=(
		$(use_enable clock-gettime)
		$(use_enable debug debug-mode)
		$(use_enable malloc-replacement malloc-replacement)
		$(use_enable mbedtls)
		$(use_enable ssl openssl)
		$(use_enable static-libs static)
		$(use_enable test libevent-regress)
		$(use_enable verbose-debug)
		--disable-samples
	)
	econf "${myconf[@]}"

	# workaround https://github.com/libevent/libevent/issues/1459
	sed -i -e 's:@CMAKE_DEBUG_POSTFIX@::' *.pc || die
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
