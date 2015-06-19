# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gmp-ecm/gmp-ecm-9999.ebuild,v 1.4 2013/11/19 07:38:58 patrick Exp $

EAPI=5

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
#SRC_URI="https://gforge.inria.fr/frs/download.php/30965/${P}.tar.gz"
ESVN_REPO_URI="svn://scm.gforge.inria.fr/svnroot/ecm/trunk"

inherit autotools eutils flag-o-matic subversion

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="blas gwnum -openmp test"

DEPEND="
	dev-libs/gmp
	blas? ( sci-libs/gsl )
	gwnum? ( sci-mathematics/gwnum )
	openmp? ( sys-devel/gcc[openmp] )"
RDEPEND="${DEPEND}"

# can't be both enabled
REQUIRED_USE="gwnum? ( !openmp )"

S=${WORKDIR}/ecm-${PV}

MAKEOPTS+=" -j1"

src_prepare() {
	eautoreconf
}

src_configure() {
	if use gwnum; then myconf="--with-gwnum=/usr/lib"; fi
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
