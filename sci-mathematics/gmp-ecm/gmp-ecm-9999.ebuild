# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
#SRC_URI="https://gforge.inria.fr/frs/download.php/30965/${P}.tar.gz"
ESVN_REPO_URI="svn://scm.gforge.inria.fr/svnroot/ecm/trunk"

inherit autotools eutils flag-o-matic subversion

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="blas -openmp test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/gmp:0=
	blas? ( sci-libs/gsl )
	openmp? ( sys-devel/gcc:*[openmp] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ecm-${PV}

MAKEOPTS+=" -j1"

src_prepare() {
	eautoreconf
}

src_configure() {
	# --enable-shellcmd is broken
	econf $(use_enable openmp) $myconf
}

src_compile() {
	append-ldflags "-Wl,-z,noexecstack"
	# the custom-tune bits are obsoleted with sane defaults
	default
}

src_install() {
	default
	mkdir -p "${D}/usr/include/${PN}/"
	cp "${S}"/*.h "${D}/usr/include/${PN}" || die "Failed to copy headers" # needed by other apps like YAFU
}
