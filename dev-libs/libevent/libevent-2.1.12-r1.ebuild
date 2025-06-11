# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal verify-sig

MY_P="${P}-stable"
DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
BASE_URI="https://github.com/libevent/libevent/releases/download/release-${MY_P#*-}"
SRC_URI="
	${BASE_URI}/${MY_P}.tar.gz
	verify-sig? (
		${BASE_URI}/${MY_P}.tar.gz.asc
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0/2.1-7"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="
	+clock-gettime debug malloc-replacement +ssl static-libs test
	verbose-debug
"
RESTRICT="!test? ( test )"

DEPEND="
	ssl? (
		>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"
BDEPEND="
	verify-sig? (
		sec-keys/openpgp-keys-libevent
	)
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)
PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch #880381
	"${FILESDIR}"/${P}-libressl.patch #903001
)
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libevent.asc

src_prepare() {
	default
	# bug #767472
	elibtoolize
}

multilib_src_configure() {
	# fix out-of-source builds
	mkdir -p test || die

	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable clock-gettime) \
		$(use_enable debug debug-mode) \
		$(use_enable malloc-replacement malloc-replacement) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable test libevent-regress) \
		$(use_enable verbose-debug) \
		--disable-samples
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

DOCS=( ChangeLog{,-1.4,-2.0} )

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
