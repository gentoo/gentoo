# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="CamlIDL is a stub code generator for using C/C++ libraries from O'Caml"
HOMEPAGE="http://caml.inria.fr/camlidl/"
SRC_URI="https://github.com/xavierleroy/${PN}/archive/${PN}$(ver_rs 0-1 '').tar.gz"

LICENSE="QPL-1.0 LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${PN}$(ver_rs 0-1 '')

PATCHES=(
	"${FILESDIR}/nowarn.patch"
)

src_prepare() {
	sed -i \
		-e "s|ar rc|$(tc-getAR) rc|g" \
		runtime/Makefile.unix \
		|| die
	default
}

src_compile() {
	# Use the UNIX makefile
	libdir=$(ocamlc -where || die)

	sed -i -e "s|OCAMLLIB=.*|OCAMLLIB=${libdir}|" config/Makefile.unix || die
	sed -i -e "s|BINDIR=.*|BINDIR=${EPREFIX}/usr/bin|" config/Makefile.unix || die
	ln -s Makefile.unix config/Makefile || die

	# Make
	emake -j1 RANLIB="$(tc-getRANLIB)" CPP="$(tc-getPROG CPP cpp)"
}

src_test() {
	einfo "Running tests..."
	cd tests || die
	emake CCPP="$(tc-getCXX)" CC="$(tc-getCC)"
}

src_install() {
	libdir=$(ocamlc -where || die)
	dodir "${libdir#${EPREFIX}}"/caml

	dodir /usr/bin
	dodir /usr/$(get_libdir)/ocaml/stublibs
	# Install
	emake BINDIR="${ED}/usr/bin" OCAMLLIB="${D}${libdir}" RANLIB="$(tc-getRANLIB)" install

	# Add package header
	sed -e "s/@VERSION/${P}/g" "${FILESDIR}/META.camlidl" >	"${D}${libdir}/META.camlidl" || die

	# Documentation
	dodoc README Changes
}
