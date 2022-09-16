# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0..1} gcc_12_2_0 )

inherit ada multiprocessing

MYP=${P}-${PV}0519-19A34-src
ID=23a77a37247ff811609e23a0a271f445c299fc8f
XMLADA=xmlada-${PV}-${PV}0518-19D50-src
XMLADAID=6a2cf72f308cc787926b12ddc20993fcf2b8ea79
ADAMIRROR=https://community.download.adacore.com/v1

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	${ADAMIRROR}/${ID}?filename=${MYP}.tar.gz -> ${MYP}.tar.gz
	${ADAMIRROR}/${XMLADAID}?filename=${XMLADA}.tar.gz -> ${XMLADA}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${ADA_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-nm.patch
	"${FILESDIR}"/${PN}-22.0.0-ar.patch
	"${FILESDIR}"/${P}-runpath.patch
)

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
