# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop fortran-2 flag-o-matic toolchain-funcs

MY_P="${PN}${PV}"

DESCRIPTION="Display molecular density from GAMESS-UK, GAMESS-US, GAUSSIAN and Mopac/Ampac"
HOMEPAGE="https://www.theochem.ru.nl/molden/"
SRC_URI="ftp://ftp.science.ru.nl/pub/Molden/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MOLDEN"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="opengl"

DEPEND="
	x11-libs/libXmu
	opengl? (
		media-libs/freeglut
		virtual/opengl
		virtual/glu
	)
"
RDEPEND="${DEPEND}
	sci-chemistry/surf
"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_prepare() {
	default
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
	emake -j1 molden ambfor/ambfor ambfor/ambmd "${args[@]}"
	if use opengl ; then
		einfo "Building Molden OpenGL helper..."
		emake -j1 "${args[@]}" gmolden
	fi
}

src_install() {
	dobin bin/molden bin/ambfor bin/ambmd
	if use opengl; then
		dobin bin/gmolden
		doicon -s 64 haux/gmolden.png
		make_desktop_entry gmolden MOLDEN gmolden
	fi

	dodoc HISTORY README REGISTER
	cd doc || die
	uncompress * && dodoc *
}
