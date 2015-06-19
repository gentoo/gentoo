# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pcre-ocaml/pcre-ocaml-7.1.5.ebuild,v 1.1 2014/12/15 10:13:58 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Perl Compatibility Regular Expressions for O'Caml"
HOMEPAGE="http://mmottl.github.io/pcre-ocaml/ https://github.com/mmottl/pcre-ocaml"
SRC_URI="https://github.com/mmottl/pcre-ocaml/releases/download/v${PV}/${P}.tar.gz"
LICENSE="LGPL-2.1-with-linking-exception"
IUSE="examples"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-lang/ocaml-4:="
DEPEND="${RDEPEND}"

DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" )

src_install() {
	oasis_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
