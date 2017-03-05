# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/32159/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blas +custom-tune gwnum -openmp static-libs test"

DEPEND="
	dev-libs/gmp:0=
	blas? ( sci-libs/gsl )
	gwnum? ( sci-mathematics/gwnum )
	openmp? ( sys-devel/gcc:*[openmp] )"
RDEPEND="${DEPEND}"

# can't be both enabled
REQUIRED_USE="gwnum? ( !openmp )"

S=${WORKDIR}/ecm-${PV}

MAKEOPTS+=" -j1"

src_prepare() {
	sed -e '/libecm_la_LIBADD/s:$: -lgmp:g' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	use gwnum && local myconf="--with-gwnum="${EPREFIX}"/usr/$(get_libdir)"
	# --enable-shellcmd is broken
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp) \
		${myconf}
}

src_compile() {
	append-ldflags "-Wl,-z,noexecstack"
	if use custom-tune; then
		use amd64 && cd x86_64
		use x86 && cd pentium4
		emake
		cd .. && make bench_mulredc || die
		sed -i -e 's:#define TUNE_MULREDC_TABLE://#define TUNE_MULREDC_TABLE:g' `readlink ecm-params.h` || die
		sed -i -e 's:#define TUNE_SQRREDC_TABLE://#define TUNE_SQRREDC_TABLE:g' `readlink ecm-params.h` || die
		./bench_mulredc | tail -n 4 >> `readlink ecm-params.h` || die
	fi
	default
}

src_install() {
	default
	mkdir -p "${ED}/usr/include/${PN}/"
	cp "${S}"/*.h "${ED}/usr/include/${PN}" || die "Failed to copy headers" # needed by other apps like YAFU
}
