# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2 flag-o-matic toolchain-funcs

#     YEAR         MONTH    DAY
MY_PV=${PV:0:4}_${PV:4:2}_${PV:6:2}
MY_P=dpsrc_${MY_PV}
# MY_PV_AUX usually ${MY_PV}
MY_PV_AUX=2009_07_15
MY_P_AUX=dplib.${MY_PV_AUX}

DESCRIPTION="Program for scientific visualization and statistical analyis"
HOMEPAGE="https://www.itl.nist.gov/div898/software/dataplot/"
SRC_URI="
	ftp://ftp.nist.gov/pub/dataplot/unix/${MY_P}.tar.gz
	ftp://ftp.nist.gov/pub/dataplot/unix/${MY_P_AUX}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples gd opengl X"

REQUIRED_USE="opengl? ( X )"

COMMON_DEPEND="
	media-libs/plotutils
	opengl? ( virtual/opengl )
	gd? ( media-libs/gd[png,jpeg] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-misc/xdg-utils )"

S_AUX="${WORKDIR}/${MY_P_AUX}"

PATCHES=( "${FILESDIR}"/${PN}-20090821-opengl.patch )

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
	default

	# bug #707176
	append-cflags -fcommon
	# bug #722208
	append-fflags $(test-flags-FC -fallow-invalid-boz)
	# another Fortran issue
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

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
		docinto examples
		dodoc -r "${S_AUX}"/data/*
	fi

	insinto /usr/share/dataplot
	doins "${S_AUX}"/dp{mes,sys,log}f.tex
	doenvd "${FILESDIR}"/90${PN}
}
