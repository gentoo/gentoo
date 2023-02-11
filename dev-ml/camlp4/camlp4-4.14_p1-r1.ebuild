# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_p/+}
MY_P=${PN}-${MY_PV}

inherit edo

DESCRIPTION="System for writing extensible parsers for programming languages"
HOMEPAGE="https://github.com/camlp4/camlp4"
SRC_URI="https://github.com/camlp4/camlp4/archive/${MY_PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${P/_p/-}

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+ocamlopt"

RDEPEND="=dev-lang/ocaml-4.14*:=[ocamlopt?]"
DEPEND="
	${RDEPEND}
	dev-ml/ocamlbuild[ocamlopt?]
	dev-ml/findlib:=
"

QA_FLAGS_IGNORED='.*'

PATCHES=( "${FILESDIR}/reload.patch" )

src_configure() {
	edo ./configure                             \
		--bindir="${EPREFIX}/usr/bin"           \
		--libdir="$(ocamlc -where)"             \
		--pkgdir="$(ocamlc -where)"
}

src_compile() {
	# Increase stack limit to 11GiB to avoid stack overflow error.
	ulimit -s 11530000

	emake byte
	use ocamlopt && emake native
}

src_install() {
	emake DESTDIR="${D}" install install-META
	dodoc CHANGES.md README.md

	if has_version ">=dev-ml/findlib-1.9" ; then
		# See bug #803275
		rm "${ED}/usr/$(get_libdir)/ocaml/camlp4/META" || die
	fi
}
