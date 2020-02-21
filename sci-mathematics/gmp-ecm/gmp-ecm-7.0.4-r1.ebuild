# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/36224/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blas +custom-tune -openmp static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/gmp:0=
	blas? ( sci-libs/gsl )
	openmp? ( sys-devel/gcc:*[openmp] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ecm-${PV}

MAKEOPTS+=" -j1"

src_prepare() {
	sed -e '/libecm_la_LIBADD/s:$: -lgmp:g' -i Makefile.am || die
	eautoreconf
}

src_configure() {
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
		emake && emake ecm-params # need to build all to get benchmark bits, then run benchmark
		emake
	fi
	default
}

src_install() {
	default
	mkdir -p "${ED}/usr/include/${PN}/"
	cp "${S}"/*.h "${ED}/usr/include/${PN}" || die "Failed to copy headers" # needed by other apps like YAFU
}
