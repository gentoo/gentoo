# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib toolchain-funcs

DESCRIPTION="OCaml interface to the Tcl/Tk GUI framework"
HOMEPAGE="https://garrigue.github.io/labltk/"
SRC_URI="https://github.com/garrigue/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="QPL-1.0 LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+ocamlopt X"

RDEPEND="dev-lang/tk:=
	>=dev-lang/ocaml-4.14:=[ocamlopt?,X(+)?]"
DEPEND="${RDEPEND}
	dev-ml/findlib
"

PATCHES=(
	"${FILESDIR}/findlib.patch"
	"${FILESDIR}"/${PN}-8.06.9-configure-clang16.patch
	"${FILESDIR}"/${P}-shuffle.patch
	"${FILESDIR}"/${P}-c2x.patch
)

src_prepare() {
	sed -i \
		-e "s|ranlib|$(tc-getRANLIB)|" \
		frx/Makefile \
		|| die
	default
}

src_configure() {
	./configure --use-findlib --verbose $(usex X "--tk-x11" "--tk-no-x11") || die "configure failed!"
}

src_compile() {
	emake -j1 all
	use ocamlopt && emake -j1 opt
}

src_install() {
	findlib_src_preinst
	dodir /usr/bin
	emake \
		INSTALLDIR="${D}/$(ocamlc -where)/labltk" \
		INSTALLBINDIR="${ED}/usr/bin/" \
		RANLIB=$(tc-getRANLIB) \
		install
	dodoc Changes README.mlTk
}
