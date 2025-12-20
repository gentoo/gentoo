# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OCaml tool to find/use non-standard packages"
HOMEPAGE="http://projects.camlcity.org/projects/findlib.html"
SRC_URI="http://download.camlcity.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc +ocamlopt tk"

DEPEND=">=dev-lang/ocaml-5:=[ocamlopt?]
	tk? ( dev-ml/labltk:= )"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default
	export ocamlfind_destdir="${EPREFIX}/usr/$(get_libdir)/ocaml"
	export stublibs="${ocamlfind_destdir}/stublibs"
	sed -i \
		-e "/dbm/d" \
		-e "/graphics/d" \
		-e "/ocamlbuild/d" \
		-e "/check_library num/d" \
		configure \
		|| die
	sed -i \
		-e "s|capitalize |capitalize_ascii |" \
		-e "s|Pervasives.||" \
		src/findlib-toolbox/make_wizard.ml \
		|| die
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

	# See bug #803275 and bug #833604
	for x in camlp4 labltk; do
		rm -rf "${ED}"/usr/$(get_libdir)/ocaml/${x} || die
	done

	for x in compiler-libs dynlink ocamldoc stdlib str threads unix; do
		rm -f "${ED}"/usr/$(get_libdir)/ocaml/${x}/META
	done
}

check_stublibs() {
	local ocaml_stdlib=$(ocamlc -where)
	local ldconf="${ocaml_stdlib}/ld.conf"

	if [[ ! -e ${ldconf} ]] ; then
		echo "${ocaml_stdlib}" > ${ldconf} || die
		echo "${ocaml_stdlib}/stublibs" >> ${ldconf} || die
	fi

	if ! grep -qe ${stublibs} ${ldconf} ; then
		echo ${stublibs} >> ${ldconf} || die
	fi
}

pkg_postinst() {
	check_stublibs
}
