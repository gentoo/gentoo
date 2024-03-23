# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )

inherit ada multiprocessing

XMLADA=xmlada-${PV}

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/AdaCore/xmlada/archive/refs/tags/v${PV}.tar.gz
		-> ${XMLADA}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="${ADA_DEPS}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( dev-python/sphinx )"

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=( "${FILESDIR}"/${PN}-22.0.0-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@GNATBIND@:${GNATBIND}:g" \
		src/gprlib.adb \
		|| die
	cd gpr/src || die
	ln -s gpr-util-put_resource_usage__unix.adb \
		gpr-util-put_resource_usage.adb
}

bin_progs="gprbuild gprconfig gprclean gprinstall gprname gprls"
lib_progs="gprlib gprbind"

src_compile() {
	local xmlada_src="../${XMLADA}"
	inc_flags="-Isrc -Igpr/src -I${xmlada_src}/sax -I${xmlada_src}/dom \
		-I${xmlada_src}/schema -I${xmlada_src}/unicode \
		-I${xmlada_src}/input_sources"

	gcc -c ${CFLAGS} gpr/src/gpr_imports.c -o gpr_imports.o || die
	for bin in ${bin_progs}; do
		gnatmake -j$(makeopts_jobs) ${inc_flags} $ADAFLAGS ${bin}-main \
			-o ${bin} -largs ${LDFLAGS} gpr_imports.o || die
	done
	for lib in $lib_progs; do
		gnatmake -j$(makeopts_jobs) ${inc_flags} ${lib} $ADAFLAGS \
			-largs ${LDFLAGS} gpr_imports.o || die
	done
	if use doc; then
		emake -C doc txt
		emake -C doc info
		emake -C doc html
	fi
}

src_install() {
	dobin ${bin_progs}
	exeinto /usr/libexec/gprbuild
	doexe ${lib_progs}
	insinto /usr/share/gpr
	doins share/_default.gpr
	local HTML_DOCS=
	local DOCS=README.md
	if use doc; then
		DOCS+=" examples doc/txt/gprbuild_ug.txt"
		HTML_DOCS+="doc/html/*"
		doinfo doc/info/gprbuild_ug.info
	fi
	einstalldocs
}
