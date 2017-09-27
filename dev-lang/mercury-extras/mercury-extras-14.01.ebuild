# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

PATCHSET_VER="1"
MY_P=mercury-srcdist-${PV}

DESCRIPTION="Additional libraries and tools that are not part of the Mercury standard library"
HOMEPAGE="http://www.mercurylang.org/index.html"
SRC_URI="http://dl.mercurylang.org/release/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X cairo examples glut iodbc ncurses odbc opengl ssl tcl tk xml"

RDEPEND="~dev-lang/mercury-${PV}
	cairo? ( >=x11-libs/cairo-1.10.0 )
	glut? ( media-libs/freeglut )
	odbc? ( dev-db/unixODBC )
	iodbc? ( !odbc? ( dev-db/libiodbc ) )
	ncurses? ( sys-libs/ncurses:= )
	opengl? (
		virtual/opengl
		virtual/glu
	)
	tcl? ( tk? (
			dev-lang/tcl:0
			dev-lang/tk:0
			x11-libs/libX11
			x11-libs/libXmu
		)
	)"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/extras

mercury_pkgs()
{
	echo   "base64
		cgi
		complex_numbers
		dynamic_linking
		error
		fixed
		lex
		moose
		posix
		solver_types/library
		$(use ncurses && echo curs curses)
		$(use glut && echo graphics/mercury_glut)
		$(use opengl && echo graphics/mercury_opengl)
		$(use tcl && use tk && echo graphics/mercury_tcltk)
		$(use odbc && echo odbc || use iodbc && echo odbc)
		$(has_version dev-lang/mercury[-minimal] && echo references)
		$(usev xml)"
}

src_prepare() {
	cd "${WORKDIR}"

	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		epatch "${WORKDIR}"/${PV}
	fi

	cd "${S}"
	if use odbc; then
		cp odbc/Mmakefile.odbc odbc/Mmakefile
	elif use iodbc; then
		cp odbc/Mmakefile.iodbc odbc/Mmakefile
	fi
}

src_compile() {
	local MERCURY_PKGS="$(mercury_pkgs)"

	# Mercury dependency generation must be run single-threaded
	mmake -j1 \
		SUBDIRS="${MERCURY_PKGS}" \
		depend || die "mmake depend failed"

	# Compiling Mercury submodules is not thread-safe
	mmake -j1 \
		SUBDIRS="${MERCURY_PKGS}" \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		|| die "mmake failed"

	if use cairo; then
		cd "${S}"/graphics/mercury_cairo
		mmc --make libmercury_cairo \
			|| die "mmc --make libmercury_cairo failed"
	fi
}

src_install() {
	local MERCURY_PKGS="$(mercury_pkgs)"

	# Compiling Mercury submodules is not thread-safe
	mmake -j1 \
		SUBDIRS="${MERCURY_PKGS}" \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		INSTALL_PREFIX="${D}"/usr \
		install || die "mmake install failed"

	if use cairo; then
		cd "${S}"/graphics/mercury_cairo
		INSTALL_PREFIX="${D}"/usr \
		mmc --make libmercury_cairo.install \
			|| die "mmc --make libmercury_cairo.install failed"
	fi

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
