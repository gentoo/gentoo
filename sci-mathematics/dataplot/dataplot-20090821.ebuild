# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fortran-2 toolchain-funcs autotools

#     YEAR         MONTH    DAY
MY_PV=${PV:0:4}_${PV:4:2}_${PV:6:2}
MY_P=dpsrc_${MY_PV}
# MY_PV_AUX usually ${MY_PV}
MY_PV_AUX=2009_07_15
MY_P_AUX=dplib.${MY_PV_AUX}

DESCRIPTION="Program for scientific visualization and statistical analyis"
HOMEPAGE="http://www.itl.nist.gov/div898/software/dataplot/"
SRC_URI="
	ftp://ftp.nist.gov/pub/dataplot/unix/${MY_P}.tar.gz
	ftp://ftp.nist.gov/pub/dataplot/unix/${MY_P_AUX}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples gd opengl X"

COMMON_DEPEND="
	media-libs/plotutils
	opengl? ( virtual/opengl )
	gd? ( media-libs/gd[png,jpeg] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-misc/xdg-utils )"

S="${WORKDIR}/${MY_P}"
S_AUX="${WORKDIR}/${MY_P_AUX}"

src_unpack() {
	# unpacking and renaming because
	# upstream does not use directories
	mkdir "${S_AUX}" || die
	pushd "${S_AUX}" > /dev/null || die
	unpack ${MY_P_AUX}.tar.gz
	popd > /dev/null || die
	mkdir ${MY_P} || die
	cd "${S}" || die
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-opengl.patch
	cp "${FILESDIR}"/Makefile.am.${PV} Makefile.am || die
	cp "${FILESDIR}"/configure.ac.${PV} configure.ac || die
	sed -e "s:IHOST1='SUN':IHOST1='@HOST@:" \
		-e "s:/usr/local/lib:@datadir@:g" \
		dp1_linux.f > dp1_linux.f.in || die
	sed -e "s/(MAXOBV=.*)/(MAXOBV=@MAXOBV@)/" \
		-e "s:/usr/local/lib:@datadir@:g" \
		DPCOPA.INC > DPCOPA.INC.in || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gd) \
		$(use_enable opengl gl) \
		$(use_enable X)
}

src_install() {
	default

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S_AUX}"/data/*
	fi
	insinto /usr/share/dataplot
	doins "${S_AUX}"/dp{mes,sys,log}f.tex
	doenvd "${FILESDIR}"/90${PN}
}
