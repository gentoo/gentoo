# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="https://libevent.org/ https://github.com/libevent/libevent/"
SRC_URI="
	https://github.com/${PN}/${PN}/releases/download/release-${PV/_/-}-stable/${P/_/-}-stable.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD"

SLOT="0/2.1-7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="debug libressl +ssl static-libs test +threads"
RESTRICT="!test? ( test )"

DEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
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

multilib_src_configure() {
	# fix out-of-source builds
	mkdir -p test || die

	ECONF_SOURCE="${S}" \
	econf \
		--disable-samples \
		$(use_enable debug debug-mode) \
		$(use_enable debug malloc-replacement) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable test libevent-regress) \
		$(use_enable threads thread-support)
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
