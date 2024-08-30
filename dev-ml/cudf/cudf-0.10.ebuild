# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune toolchain-funcs

MYP=${PN}-v${PV}
DESCRIPTION="Library to parse, pretty print, and evaluate CUDF documents"
HOMEPAGE="http://www.mancoosi.org/cudf/"
SRC_URI="https://gitlab.com/irill/${PN}/-/archive/v${PV}/${MYP}.tar.bz2"

S="${WORKDIR}"/${MYP}

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/extlib:=
	dev-ml/findlib:=
	dev-libs/glib:2
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit2 )
	dev-ml/ocamlbuild
	dev-lang/perl
"
BDEPEND="virtual/pkgconfig"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default

	sed -i \
		-e 's|make|$(MAKE)|g' \
		Makefile || die
	sed -i \
		-e 's|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0) -lunwind|g' \
		-e "s|ar r|$(tc-getAR) r|g" \
		c-lib/Makefile || die
	sed -i \
		-e 's|-lcurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0) -lunwind|g' \
		c-lib/Makefile.variants || die

	tc-export CC PKG_CONFIG

	sed -i \
		-e "s|-lncurses|$( $(tc-getPKG_CONFIG) --libs ncurses)|g" \
		c-lib/cudf.pc.in || die
}

src_compile() {
	dune_src_compile
	emake c-lib
	if use ocamlopt ; then
		emake c-lib-opt
	fi
}

src_test() {
	dune_src_test
	emake c-lib-test
}

src_install() {
	dune_src_install
	mv "${ED}"/usr/share/doc/${PF}/{cudf/README,} || die
	rmdir "${ED}"/usr/share/doc/${PF}/cudf || die
	emake DESTDIR="${ED}" -C c-lib/ LIBDIR="/usr/$(get_libdir)" -e install
	dodoc BUGS ChangeLog
}
