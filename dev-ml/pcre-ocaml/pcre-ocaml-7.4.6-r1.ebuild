# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Perl Compatibility Regular Expressions for O'Caml"
HOMEPAGE="http://mmottl.github.io/pcre-ocaml/ https://github.com/mmottl/pcre-ocaml"
SRC_URI="https://github.com/mmottl/pcre-ocaml/releases/download/${PV}/pcre-${PV}.tbz -> ${P}.tbz"
S="${WORKDIR}/pcre-${PV}"

LICENSE="LGPL-2.1-with-linking-exception"
IUSE="examples +ocamlopt"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

BDEPEND="dev-ml/dune-configurator"
RDEPEND=">=dev-libs/libpcre-4.5"
DEPEND="
	${RDEPEND}
	dev-ml/stdio
"

src_install() {
	dune_src_install pcre

	if use examples ; then
		dodoc -r examples
	fi
}
