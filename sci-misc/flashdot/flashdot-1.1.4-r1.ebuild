# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Generator for psychophysical experiments"
HOMEPAGE="http://www.flashdot.info/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~tomka/files/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-3.10:=[ocamlopt?]
	dev-ml/gsl-ocaml:=
	dev-ml/lablgl:=[glut]
	dev-ml/ocamlsdl:=[opengl]
	x11-apps/xdpyinfo"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/${P}-gsl-ocaml.patch"
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-ocaml-4.09.patch
)

src_prepare() {
	default
	MAKEOPTS="-j1"
	use ocamlopt || MAKEOPTS+=" TARGETS=flashdot_bytecode BYTECODENAME=flashdot"
	sed -i \
		-e "s|^VERSION.*|VERSION := ${PV}|" \
		Makefile \
		|| die
	sed -i \
		-e 's:Gsl_matrix:Gsl.Matrix:g' \
		-e 's:Gsl_rng:Gsl.Rng:g' \
		-e 's:Gsl_randist:Gsl.Randist:g' \
		-e 's:Gsl_sf:Gsl.Sf:g' \
		-e 's:Gsl_math:Gsl.Math:g' \
		-e 's:Gsl_vector:Gsl.Vector:g' \
		-e 's:Gsl_permut:Gsl.Permut:g' \
		-e 's:Gsl_linalg:Gsl.Linalg:g' \
		-e 's:Gsl_cdf:Gsl.Cdf:g' \
		mathexpr/mathexpr.ml \
		mathexpr/mathexpr.mli \
		mathexpr/random_rng.ml \
		mathexpr/sequences.ml \
		mathexpr/multibin.ml \
		flashdot.ml \
		|| die
}

src_configure() {
	./configure --prefix=/usr || die
}

src_install() {
	emake DESTDIR="${D}" CALLMODE=script install
	rm "${D}"/usr/share/doc/${PN}/copyright* || die
	mv "${D}"/usr/share/doc/{${PN},${PF}} || die
}
