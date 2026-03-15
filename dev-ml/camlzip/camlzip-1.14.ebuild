# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Compressed file access ML library (ZIP, GZIP and JAR)"
HOMEPAGE="https://github.com/xavierleroy/camlzip"
SRC_URI="https://github.com/xavierleroy/camlzip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.13:=[ocamlopt?]
	>=virtual/zlib-1.1.3:="
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED=(
	"usr/lib.*/ocaml/stublibs/dllcamlzip.so"
	"usr/lib.*/ocaml/zip/zip.cmxs"
)

src_compile() {
	emake allbyt

	if use ocamlopt; then
		emake allopt
	fi
}

src_test() {
	emake -C test
}

src_install() {
	findlib_src_preinst

	emake DESTDIR="${D}" install-findlib
	dosym zip/libcamlzip.a /usr/$(get_libdir)/ocaml/libcamlzip.a

	dodoc README.md Changes
}
