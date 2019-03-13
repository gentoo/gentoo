# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="Perl Compatibility Regular Expressions for O'Caml"
HOMEPAGE="http://mmottl.github.io/pcre-ocaml/ https://github.com/mmottl/pcre-ocaml"
SRC_URI="https://github.com/mmottl/pcre-ocaml/releases/download/${PV}/pcre-${PV}.tbz -> ${P}.tbz"
LICENSE="LGPL-2.1-with-linking-exception"
IUSE="examples"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

RDEPEND=">=dev-libs/libpcre-4.5"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/base
	dev-ml/stdio
	dev-ml/configurator
"

S="${WORKDIR}/pcre-${PV}"

src_compile() {
	jbuilder build @install || die
}

src_test() {
	jbuilder runtest || die
}

src_install() {
	opam_src_install pcre

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
