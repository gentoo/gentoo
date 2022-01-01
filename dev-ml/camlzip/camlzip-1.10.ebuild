# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

IUSE="+ocamlopt"

DESCRIPTION="Compressed file access ML library (ZIP, GZIP and JAR)"
HOMEPAGE="https://github.com/xavierleroy/camlzip"
SRC_URI="https://github.com/xavierleroy/camlzip/archive/rel$(ver_rs 1- '').tar.gz -> ${P}.tar.gz"

SLOT="1/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"

RDEPEND=">=dev-lang/ocaml-4.05:=[ocamlopt?]
		>=sys-libs/zlib-1.1.3"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED=(
	"/usr/lib.*/ocaml/stublibs/dllcamlzip.so"
	"/usr/lib.*/ocaml/zip/zip.cmxs"
)

S="${WORKDIR}/${PN}-rel$(ver_rs 1- '')"

src_compile() {
	emake all
	if use ocamlopt; then
		emake allopt
	fi
}

src_install() {
	findlib_src_preinst
	emake DESTDIR="${D}" install-findlib
	dosym zip/libcamlzip.a /usr/$(get_libdir)/ocaml/libcamlzip.a

	dodoc README Changes
}
