# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
SRC_URI="
	https://github.com/${PN}/${PN}/releases/download/release-${PV/_/-}-stable/${P/_/-}-stable.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD"

SLOT="0/2.1-7"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="
	+clock-gettime debug malloc-replacement +ssl static-libs test
	+threads verbose-debug
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
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)
S=${WORKDIR}/${P/_/-}-stable

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
		$(use_enable threads thread-support) \
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
