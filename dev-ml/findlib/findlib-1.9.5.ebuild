# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OCaml tool to find/use non-standard packages"
HOMEPAGE="http://projects.camlcity.org/projects/findlib.html"
SRC_URI="http://download.camlcity.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc +ocamlopt tk"

DEPEND=">=dev-lang/ocaml-4.02.3-r1:=[ocamlopt?]
	tk? ( dev-ml/labltk:= )"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default
	export ocamlfind_destdir="${EPREFIX}/usr/$(get_libdir)/ocaml"
	export stublibs="${ocamlfind_destdir}/stublibs"
}

src_configure() {
	local myconf
	use tk && myconf="-with-toolbox"
	./configure -bindir "${EPREFIX}"/usr/bin -mandir "${EPREFIX}"/usr/share/man \
		-sitelib ${ocamlfind_destdir} \
		-config ${ocamlfind_destdir}/findlib/findlib.conf \
		-no-custom \
		${myconf} || die "configure failed"
}

src_compile() {
	emake -j1 all
	if use ocamlopt; then
		emake -j1 opt # optimized code
	fi
}

src_install() {
	emake prefix="${D}" install

	dodir "${stublibs#${EPREFIX}}"

	if use doc; then
		cd "${S}/doc" || die
		dodoc QUICKSTART README DOCINFO
		docinto html
		dodoc -r ref-html guide-html
	fi
}

check_stublibs() {
	local ocaml_stdlib=`ocamlc -where`
	local ldconf="${ocaml_stdlib}/ld.conf"

	if [ ! -e ${ldconf} ]
	then
		echo "${ocaml_stdlib}" > ${ldconf}
		echo "${ocaml_stdlib}/stublibs" >> ${ldconf}
	fi

	if [ -z `grep -e ${stublibs} ${ldconf}` ]
	then
		echo ${stublibs} >> ${ldconf}
	fi
}

pkg_postinst() {
	check_stublibs
}
