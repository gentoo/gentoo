# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multiprocessing

MYP=${P}-20190517-194D8-src
XMLADA=xmlada-${PV}-20190429-19B9D-src

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	http://mirrors.cdn.adacore.com/art/5cdf8e8031e87a8f1d425093
		-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/5cdf916831e87a8f1d4250b5
		-> ${XMLADA}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2017 gnat_2018 +gnat_2019"

DEPEND="gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )
	gnat_2019? ( dev-lang/gnat-gpl:8.3.1 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}

REQUIRED_USE="^^ ( gnat_2017 gnat_2018 gnat_2019 )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	if use gnat_2017; then
		GCC_PV=6.3.0
	elif use gnat_2018; then
		GCC_PV=7.3.1
	else
		GCC_PV=8.3.1
	fi
	default
	sed -i \
		-e "s:@VER@:${GCC_PV}:g" \
		share/gprconfig/compilers.xml \
		share/gprconfig/gnat.xml \
		share/gprconfig/c.xml \
		share/gprconfig/linker.xml \
		|| die
	sed -i \
		-e "s:@GNATBIND@:gnatbind-${GCC_PV}:g" \
		src/gprlib.adb \
		|| die
}

src_configure() {
	emake prefix="${D}"usr setup
}

bin_progs="gprbuild gprconfig gprclean gprinstall gprname gprls"
lib_progs="gprlib gprbind"

src_compile() {
	GCC=${CHOST}-gcc-${GCC_PV}
	GNATMAKE=${CHOST}-gnatmake-${GCC_PV}
	local xmlada_src="../${XMLADA}"
	incflags="-Isrc -Igpr/src -I${xmlada_src}/sax -I${xmlada_src}/dom \
		-I${xmlada_src}/schema -I${xmlada_src}/unicode \
		-I${xmlada_src}/input_sources"
	${GCC} -c ${CFLAGS} gpr/src/gpr_imports.c -o gpr_imports.o || die
	for bin in ${bin_progs}; do
		${GNATMAKE} -j$(makeopts_jobs) ${incflags} $ADAFLAGS ${bin}-main \
			-o ${bin} -largs gpr_imports.o || die
	done
	for lib in $lib_progs; do
		${GNATMAKE} -j$(makeopts_jobs) ${incflags} ${lib} $ADAFLAGS \
			-largs gpr_imports.o || die
	done
}

src_install() {
	dobin ${bin_progs}
	exeinto /usr/libexec/gprbuild
	doexe ${lib_progs}
	insinto /usr/share/gprconfig
	doins share/gprconfig/*
	insinto /usr/share/gpr
	doins share/_default.gpr
	einstalldocs
}
