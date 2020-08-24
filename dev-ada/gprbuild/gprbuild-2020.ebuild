# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_201{7,8,9} )

inherit ada toolchain-funcs multiprocessing

MYP=${P}-20200429-19BD2-src
XMLADA=xmlada-${PV}-20200429-19A99-src

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	https://community.download.adacore.com/v1/408ec35c3bb86bd227db3da55d3e1e0c572a56e3?filename=${MYP}.tar.gz
		-> ${MYP}.tar.gz
	https://community.download.adacore.com/v1/c799502295baf074ad17b48c50f621879c392c57?filename=${XMLADA}.tar.gz
		-> ${XMLADA}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="${ADA_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@VER@:${GCC_PV}:g" \
		share/gprconfig/compilers.xml \
		share/gprconfig/gnat.xml \
		share/gprconfig/c.xml \
		share/gprconfig/linker.xml \
		|| die
	sed -i \
		-e "s:@GNATBIND@:${GNATBIND}:g" \
		src/gprlib.adb \
		|| die
}

src_configure() {
	emake prefix="${D}"/usr setup
}

bin_progs="gprbuild gprconfig gprclean gprinstall gprname gprls"
lib_progs="gprlib gprbind"

src_compile() {
	local xmlada_src="../${XMLADA}"
	incflags="-Isrc -Igpr/src -I${xmlada_src}/sax -I${xmlada_src}/dom \
		-I${xmlada_src}/schema -I${xmlada_src}/unicode \
		-I${xmlada_src}/input_sources"
	gcc -c ${CFLAGS} gpr/src/gpr_imports.c -o gpr_imports.o || die
	for bin in ${bin_progs}; do
		gnatmake -j$(makeopts_jobs) ${incflags} $ADAFLAGS ${bin}-main \
			-o ${bin} -largs ${LDFLAGS} gpr_imports.o || die
	done
	for lib in $lib_progs; do
		gnatmake -j$(makeopts_jobs) ${incflags} ${lib} $ADAFLAGS \
			-largs ${LDFLAGS} gpr_imports.o || die
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
