# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/cppo/cppo-0.9.3.ebuild,v 1.1 2013/07/23 18:05:39 aballier Exp $

EAPI="5"

DESCRIPTION="An equivalent of the C preprocessor for OCaml programs"
HOMEPAGE="http://mjambon.com/cppo.html"
SRC_URI="http://mjambon.com/releases/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"

IUSE="examples"

RDEPEND=">=dev-lang/ocaml-3.12:="
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p "${ED}"/usr/bin
	emake PREFIX="${ED}"/usr install
	dodoc README Changes
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
