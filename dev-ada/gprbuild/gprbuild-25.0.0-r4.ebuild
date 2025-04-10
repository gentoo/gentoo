# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_12 gcc_13 gcc_14 )
PYTHON_COMPAT=( python3_{10..13} pypy3{,_11} )
inherit ada python-any-r1 multiprocessing

XMLADA=xmlada-${PV}

DESCRIPTION="Multi-Language Management"
HOMEPAGE="https://github.com/AdaCore/gprbuild"
SRC_URI="
	https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/AdaCore/xmlada/archive/refs/tags/v${PV}.tar.gz
		-> ${XMLADA}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"

DEPEND="${ADA_DEPS}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="doc? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
)"

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=( "${FILESDIR}"/${PN}-22.0.0-gentoo.patch )

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	sed -i \
		-e "s:@GNATBIND@:${GNATBIND}:g" \
		src/gprlib.adb \
		|| die
	sed -i \
		-e "s|\"gnatbind\"|\"gnatbind-${GCC_PV}\"|" \
		src/gprbind.adb \
		|| die
	sed -i \
		-e "s:18.0w:$(ver_cut 1-2):" \
		-e "/Build_Type :/s:Gnatpro:FSF:" \
		gpr/src/gpr-version.ads \
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
	use doc && emake -C doc html
}

src_install() {
	dobin ${bin_progs}
	exeinto /usr/libexec/gprbuild
	doexe ${lib_progs}
	insinto /usr/share/gpr
	doins share/_default.gpr
	local DOCS=README.md
	use doc && HTML_DOCS="doc/html/*"
	einstalldocs
}
