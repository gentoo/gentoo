# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_p/+}
MY_P=${PN}-${MY_PV}

DESCRIPTION="System for writing extensible parsers for programming languages"
HOMEPAGE="https://github.com/camlp4/camlp4"
SRC_URI="https://github.com/camlp4/camlp4/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:0/4.09[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild[ocamlopt?]
	dev-ml/findlib:="

QA_FLAGS_IGNORED='.*'

S=${WORKDIR}/${P/_p/-}
PATCHES=( "${FILESDIR}/reload.patch" )

src_configure() {
	./configure \
		--bindir="${EPREFIX}/usr/bin" \
		--libdir="$(ocamlc -where)" \
		--pkgdir="$(ocamlc -where)" \
		|| die
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
