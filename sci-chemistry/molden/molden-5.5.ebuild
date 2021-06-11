# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop fortran-2 flag-o-matic toolchain-funcs

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
		virtual/opengl )
"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	app-editors/vim"
	# vim provides ex, which the build system uses (surf/Makefile, at least)

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0-ambfor.patch
	"${FILESDIR}"/${PN}-5.0-overflow.patch
	"${FILESDIR}"/${PN}-4.8-ldflags.patch
	"${FILESDIR}"/${PN}-4.7-implicit-dec.patch
	"${FILESDIR}"/${PN}-5.5-gcc8.patch
)

src_prepare() {
	default
	sed \
		-e 's:makedepend:gccmakedep:g' \
		-i surf/Makefile || die
	sed 's:shell g77:shell $(FC):g' -i makefile || die
}

src_compile() {
	local args=()

	# Use -mieee on alpha, according to the Makefile
	use alpha && append-flags -mieee

	# GCC 10 workaround
	# bug #724556
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	args=(
		CC="$(tc-getCC) ${CFLAGS}"
		FC="$(tc-getFC)"
		LDR="$(tc-getFC)"
		FFLAGS="${FFLAGS}"
	)

	einfo "Building Molden..."
	emake -j1 "${args[@]}"
	if use opengl ; then
		einfo "Building Molden OpenGL helper..."
		emake -j1 "${args[@]}" moldenogl
	fi
}

src_install() {
	dobin ${PN} g${PN} $(usex opengl ${PN}ogl "")
	doicon gmolden.png
	make_desktop_entry gmolden MOLDEN gmolden.png

	dodoc HISTORY README REGISTER
	cd doc || die
	uncompress * && dodoc *
}
