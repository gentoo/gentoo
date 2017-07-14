# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	http://mirrors.cdn.adacore.com/art/57399662c7a447658e0affa8
		-> ${MYP}-src.tar.gz
	bootstrap? (
		http://mirrors.cdn.adacore.com/art/57399978c7a447658e0affc0
		-> xmlada-gpl-${PV}-src.tar.gz )"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bootstrap gnat_2016 gnat_2017 +shared static static-pic"

DEPEND="!bootstrap? ( dev-ada/xmlada[static,gnat_2016=,gnat_2017=] )
	gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}-src

REQUIRED_USE="bootstrap? ( !shared !static !static-pic )
	^^ ( gnat_2016 gnat_2017 )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	sed -e "s:@VER@:${GCC_PV}:g" "${FILESDIR}"/${P}.xml > gnat-${GCC_PV}.xml
	default
}

src_configure() {
	if ! use bootstrap ; then
		default
	fi
}

bin_progs="gprbuild gprconfig gprclean gprinstall gprname gprls"
lib_progs="gprlib gprbind"

src_compile() {
	GCC=${CHOST}-gcc-${GCC_PV}
	if use bootstrap; then
		GNATMAKE=${CHOST}-gnatmake-${GCC_PV}
		local xmlada_src="../xmlada-gpl-${PV}-src"
		incflags="-Isrc -Igpr/src -I${xmlada_src}/sax -I${xmlada_src}/dom \
			-I${xmlada_src}/schema -I${xmlada_src}/unicode \
			-I${xmlada_src}/input_sources"
		${GCC} -c ${CFLAGS} src/gpr_imports.c -o gpr_imports.o || die
		for bin in ${bin_progs}; do
			${GNATMAKE} -j$(makeopts_jobs) ${incflags} $ADAFLAGS ${bin}-main \
				-o ${bin} -largs gpr_imports.o || die
		done
		for lib in $lib_progs; do
			${GNATMAKE} -j$(makeopts_jobs) ${incflags} ${lib} $ADAFLAGS \
				-largs gpr_imports.o || die
		done
	else
		emake PROCESSORS=$(makeopts_jobs) all
		for kind in shared static static-pic; do
			if use ${kind}; then
				emake PROCESSORS=$(makeopts_jobs) libgpr.build.${kind}
			fi
		done
	fi
}

src_install() {
	if use bootstrap; then
		dobin ${bin_progs}
		exeinto /usr/libexec/gprbuild
		doexe ${lib_progs}
		insinto /usr/share/gprconfig
		doins share/gprconfig/*
		insinto /usr/share/gpr
		doins share/_default.gpr
	else
		default
		for kind in shared static static-pic; do
			if use ${kind}; then
				emake DESTDIR="${D}" libgpr.install.${kind}
			fi
		done
	fi
	insinto /usr/share/gprconfig
	doins gnat-${GCC_PV}.xml
	einstalldocs
}
