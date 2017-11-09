# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

MY_P="postgresql-${PV}"

DESCRIPTION="A package for ocaml that provides access to PostgreSQL databases"
SRC_URI="https://github.com/mmottl/postgresql-ocaml/releases/download/${PV}/${MY_P}.tbz"
HOMEPAGE="http://mmottl.github.io/postgresql-ocaml/"
IUSE=""

RDEPEND="
	dev-db/postgresql:=[server]
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	>=dev-ml/findlib-1.5"

SLOT="0/${PV}"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${MY_P}"

src_compile() {
	jbuilder build @install || die
}

src_install() {
	opam_src_install "postgresql"
}
