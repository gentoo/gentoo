# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils fortran-2 flag-o-matic toolchain-funcs

MY_P="${PN}${PV}"

DESCRIPTION="Display molecular density from GAMESS-UK, GAMESS-US, GAUSSIAN and Mopac/Ampac"
HOMEPAGE="http://www.cmbi.ru.nl/molden/"
SRC_URI="ftp://ftp.cmbi.ru.nl/pub/molgraph/${PN}/${MY_P}.tar.gz"

LICENSE="MOLDEN"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="opengl"

RDEPEND="
	x11-libs/libXmu
		virtual/glu
	opengl? (
		media-libs/freeglut
		virtual/opengl )"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	app-editors/vim"
	# vim provides ex, which the build system uses (surf/Makefile, at least)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ambfor.patch \
		"${FILESDIR}"/${P}-overflow.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${PN}-4.7-implicit-dec.patch
	sed \
		-e 's:makedepend:gccmakedep:g' \
		-e "s:/usr/include/sgidefs.h::g" \
		-i surf/Makefile || die
	sed 's:shell g77:shell $(FC):g' -i makefile || die
}

src_compile() {
	# Use -mieee on alpha, according to the Makefile
	use alpha && append-flags -mieee

	# Honor CC, CFLAGS, FC, and FFLAGS from environment;
	# unfortunately a bash bug prevents us from doing typeset and
	# assignment on the same line.
	typeset -a args
	args=(
			CC="$(tc-getCC) ${CFLAGS}" \
			FC="$(tc-getFC)" \
			LDR="$(tc-getFC)" \
			FFLAGS="${FFLAGS}" )

	einfo "Building Molden..."
	emake -j1 "${args[@]}"
	if use opengl ; then
		einfo "Building Molden OpenGL helper..."
		emake -j1 "${args[@]}" moldenogl
	fi
}

src_install() {
	dobin ${PN} g${PN}
	if use opengl ; then
		dobin ${PN}ogl
	fi

	dodoc HISTORY README REGISTER
	cd doc
	uncompress * && dodoc *
}
