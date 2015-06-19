# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gimp-gmic/gimp-gmic-1.6.0.2-r1.ebuild,v 1.1 2014/12/08 03:23:48 radhermit Exp $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="G'MIC GIMP plugin"
HOMEPAGE="http://gmic.sourceforge.net/gimp.shtml"
SRC_URI="mirror://sourceforge/gmic/gmic_${PV}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND="
	>=media-gfx/gimp-2.4.0
	media-libs/libpng:0=
	sci-libs/fftw:3.0[threads]
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/gmic-${PV}/src

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/gmic-${PV}-makefile.patch

	if ! use openmp ; then
		sed -i -r "s/^(OPENMP_(CFLAGS|LIBS) =).*/\1/" Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" OPT_CFLAGS= DEBUG_CFLAGS= gimp
}

src_install() {
	emake DESTDIR="${D}" install-gimp
	dodoc ../README
}

pkg_postinst() {
	elog "The G'MIC plugin is accessible from the menu:"
	elog "Filters -> G'MIC"
}
