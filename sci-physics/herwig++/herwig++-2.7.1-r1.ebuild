# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils eutils flag-o-matic multilib

MYP=Herwig++-${PV}

DESCRIPTION="High-Energy Physics event generator"
HOMEPAGE="http://herwig.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/herwig/${MYP}.tar.bz2"

SLOT="0/15"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="c++11 fastjet static-libs"

# >sci-physics/looptools-2.8 leads to misoperation
# and failing tests (it lacks some symbols)
RDEPEND="
	dev-libs/boost:0=
	sci-libs/gsl:0=
	<=sci-physics/looptools-2.8:0=
	~sci-physics/thepeg-1.9.2:0=
	fastjet? ( sci-physics/fastjet:0= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.3-looptools.patch
	find -name 'Makefile.am' -exec \
		sed -i -e '1ipkgdatadir=$(datadir)/herwig++' {} \; || die
	autotools-utils_src_prepare
}

src_configure() {
	use prefix && \
		append-ldflags -Wl,-rpath,"${EPREFIX}"/usr/$(get_libdir)/ThePEG
	local myeconfargs=(
		--with-boost="${EPREFIX}"/usr
		--with-thepeg="${EPREFIX}"/usr
		$(use_enable c++11 stdcxx11)
		$(use_with fastjet fastjet "${EPREFIX}"/usr)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	sed -i -e "s|${ED}||g" "${ED}"/usr/share/herwig++/defaults/PDF.in || die
	sed -i -e "s|${ED}||g" "${ED}"/usr/share/herwig++/HerwigDefaults.rpo || die
}
