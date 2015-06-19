# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mercury-extras/mercury-extras-11.01.ebuild,v 1.10 2015/03/21 11:41:50 jlec Exp $

EAPI=2

inherit eutils multilib

PATCHSET_VER="2"

DESCRIPTION="Additional libraries and tools that are not part of the Mercury standard library"
HOMEPAGE="http://www.cs.mu.oz.au/research/mercury/index.html"
SRC_URI="http://www.mercury.cs.mu.oz.au/download/files/${P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="X cairo examples glut iodbc ncurses odbc opengl ssl tcl tk xml"

RDEPEND="~dev-lang/mercury-${PV}
	cairo? ( >=x11-libs/cairo-1.10.0 )
	glut? ( media-libs/freeglut )
	odbc? ( dev-db/unixODBC )
	iodbc? ( !odbc? ( dev-db/libiodbc ) )
	ncurses? ( sys-libs/ncurses )
	opengl? ( virtual/opengl )
	tcl? ( tk? (
			dev-lang/tcl:0
			dev-lang/tk:0
			x11-libs/libX11
			x11-libs/libXmu ) )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}

src_prepare() {
	cd "${WORKDIR}"

	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}

	if use odbc; then
		epatch "${WORKDIR}"/${PV}-odbc/${P}-odbc.patch
	elif use iodbc; then
		epatch "${WORKDIR}"/${PV}-odbc/${P}-iodbc.patch
	fi

	cd "${S}"
	sed -i	-e "s:references:references solver_types/library:" \
		-e "s:windows_installer_generator::" \
		Mmakefile || die "sed default packages failed"

	if use cairo; then
		sed -i -e "s: lex : graphics/mercury_cairo lex :" Mmakefile \
			|| die "sed cairo failed"
	fi

	if use glut; then
		sed -i -e "s: lex : graphics/mercury_glut lex :" Mmakefile \
			|| die "sed glut failed"
	fi

	if use opengl; then
		sed -i -e "s: lex : graphics/mercury_opengl lex :" Mmakefile \
			|| die "sed opengl failed"
	fi

	if use tcl && use tk; then
		sed -i -e "s: lex : graphics/mercury_tcltk lex :" Mmakefile \
			|| die "sed tcltk failed"
	fi

	if use odbc || use iodbc; then
		sed -i -e "s:moose:moose odbc:" Mmakefile \
			|| die "sed odbc failed"
	fi

	if ! use ncurses; then
		sed -i -e "s:curs curses::" Mmakefile \
			|| die "sed ncurses failed"
	fi

	if ! use xml; then
		sed -i -e "s:xml::" Mmakefile \
			|| die "sed xml failed"
	fi

	sed -i -e "s:@libdir@:$(get_libdir):" \
		dynamic_linking/Mmakefile posix/Mmakefile \
		|| die "sed libdir failed"

	# disable broken packages
	sed -i -e "s:lazy_evaluation::" -e "s:references::" Mmakefile \
		|| die "sed broken packages failed"
}

src_compile() {
	# Mercury dependency generation must be run single-threaded
	mmake \
		-j1 depend || die "mmake depend failed"

	mmake \
		MMAKEFLAGS="${MAKEOPTS}" \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		|| die "mmake failed"
}

src_install() {
	mmake \
		MMAKEFLAGS="${MAKEOPTS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		INSTALL_PREFIX="${D}"/usr \
		install || die "mmake install failed"

	find "${D}"/usr/$(get_libdir)/mercury -type l | xargs rm

	cd "${S}"
	if use examples; then
		insinto /usr/share/doc/${PF}/samples/base64
		doins base64/*.m || die

		insinto /usr/share/doc/${PF}/samples/complex_numbers
		doins complex_numbers/samples/* || die

		insinto /usr/share/doc/${PF}/samples/dynamic_linking
		doins dynamic_linking/hello.m || die

		insinto /usr/share/doc/${PF}/samples/error
		doins error/* || die

		insinto /usr/share/doc/${PF}/samples/fixed
		doins fixed/*.m || die

		insinto /usr/share/doc/${PF}/samples/gator
		doins -r gator/* || die

		insinto /usr/share/doc/${PF}/samples/lex
		doins lex/samples/* || die

		insinto /usr/share/doc/${PF}/samples/log4m
		doins log4m/*.m || die

		insinto /usr/share/doc/${PF}/samples/monte
		doins monte/*.m || die

		insinto /usr/share/doc/${PF}/samples/moose
		doins moose/samples/* || die

		insinto /usr/share/doc/${PF}/samples/net
		doins net/*.m || die

		if use ncurses; then
			insinto /usr/share/doc/${PF}/samples/curs
			doins curs/samples/* || die

			insinto /usr/share/doc/${PF}/samples/curses
			doins curses/sample/* || die
		fi

		if use X; then
			insinto /usr/share/doc/${PF}/samples/graphics
			doins graphics/easyx/samples/*.m || die
		fi

		if use glut && use opengl; then
			insinto /usr/share/doc/${PF}/samples/graphics
			doins graphics/samples/calc/* || die
			doins graphics/samples/gears/* || die
			doins graphics/samples/maze/* || die
			doins graphics/samples/pent/* || die
		fi

		if use opengl && use tcl && use tk; then
			insinto /usr/share/doc/${PF}/samples/graphics
			doins graphics/samples/pent/*.m || die
		fi

		if use ssl; then
			insinto /usr/share/doc/${PF}/samples/mopenssl
			doins mopenssl/*.m || die
		fi

		ecvs_clean
	fi

	dodoc README || die
}
