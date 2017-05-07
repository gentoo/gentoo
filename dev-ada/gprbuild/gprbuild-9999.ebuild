# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Multi-Language Management"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	bootstrap? (
		http://mirrors.cdn.adacore.com/art/57399978c7a447658e0affc0
		-> xmlada-gpl-2016-src.tar.gz )"
EGIT_REPO_URI="https://github.com/AdaCore/gprbuild.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="bootstrap +shared static static-pic"

DEPEND="dev-lang/gnat-gpl
	>=dev-python/sphinx-1.5.2
	!bootstrap? ( dev-ada/xmlada )"
RDEPEND="${DEPEND}"

REQUIRED_USE="bootstrap? ( !shared !static !static-pic )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	GNATMAKE="${GCC/gcc/gnatmake}"
	if [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-4.9.4 in make.conf"
		die "ada compiler not available"
	fi
}

src_unpack() {
	git-r3_src_unpack
	default
}
src_prepare() {
	sed -i \
		-e "/gnatls/d" \
		Makefile || die
	default
}

src_configure() {
	make prefix="${D}"usr setup
	default
}

bin_progs="gprbuild gprconfig gprclean gprinstall gprname gprls"
lib_progs="gprlib gprbind"

src_compile() {
	if use bootstrap; then
		local xmlada_src="../xmlada-gpl-2016-src"
		incflags="-Isrc -Igpr/src -I${xmlada_src}/sax -I${xmlada_src}/dom \
			-I${xmlada_src}/schema -I${xmlada_src}/unicode \
			-I${xmlada_src}/input_sources"
		$(tc-getCC) -c ${CFLAGS} gpr/src/gpr_imports.c -o gpr_imports.o
		for bin in ${bin_progs}; do
			${GNATMAKE} -j$(makeopts_jobs) ${incflags} $ADAFLAGS ${bin}-main \
				-o ${bin} -largs gpr_imports.o || die
		done
		for lib in $lib_progs; do
			${GNATMAKE} -j$(makeopts_jobs) ${incflags} ${lib} $ADAFLAGS \
				-largs gpr_imports.o || die
		done
	else
		emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v all
		for kind in shared static static-pic; do
			if use ${kind}; then
				emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v \
					libgpr.build.${kind}
			fi
		done
		emake -C doc html
		emake -C doc txt
		emake -C doc texinfo
		emake -C doc info
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
		mv "${D}"/usr/share/examples/${PN} "${D}"/usr/share/doc/${PF}/examples || die
		rmdir "${D}"/usr/share/examples || die
	fi
	einstalldocs
}
