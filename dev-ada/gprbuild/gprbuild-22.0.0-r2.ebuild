# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0,1} gcc_12_2_0 )

inherit ada multiprocessing

XMLADA=xmlada-${PV}
GPRCONFIG_KB=gprconfig_kb-${PV}

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/AdaCore/xmlada/archive/refs/tags/v${PV}.tar.gz
		-> ${XMLADA}.tar.gz
	https://github.com/AdaCore/gprconfig_kb/archive/refs/tags/v${PV}.tar.gz
		-> ${GPRCONFIG_KB}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${ADA_DEPS}"
RDEPEND="${DEPEND}"

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-nm.patch
	"${FILESDIR}"/${P}-ar.patch
	"${FILESDIR}"/${PN}-2021-runpath.patch
)

src_prepare() {
	kb_src=../${GPRCONFIG_KB}

	# Install the gprconfig knowledge base
	rm -rf share/gprconfig
	cp -r "$kb_src"/db share/gprconfig || die

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
	if use ada_target_gnat_2020; then
		sed -i \
			-e "s:Append_Vector:Append:g" \
			-e "s:Insert_Vector:Insert:g" \
			src/gprbuild-link.adb \
			src/gprinstall-install.adb \
			src/gprlib.adb \
			src/gprlib-build_shared_lib.adb \
			src/gprbind.adb \
			|| die
		eapply "${FILESDIR}"/${P}-2020.patch
	fi
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
	doins share/gprconfig/*.xml
	doins share/gprconfig/*.ent
	insinto /usr/share/gpr
	doins share/_default.gpr
	einstalldocs
}
