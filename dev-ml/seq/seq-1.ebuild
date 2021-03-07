# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Compatibility package for OCaml's standard iterator type starting from 4.07."
HOMEPAGE="https://github.com/ocaml/opam-repository/blob/master/packages/seq/seq.base/opam"
SRC_URI=""

LICENSE="public-domain"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
"
BDEPEND=""
S="${WORKDIR}"

src_prepare() {
	cp "${FILESDIR}/"{seq.install,META.seq} "${S}/" || die
	default
}
