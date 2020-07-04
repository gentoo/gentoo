# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="GLib integration for Lwt"
SRC_URI="https://github.com/ocsigen/lwt/archive/${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE=""

RDEPEND="
	>=dev-ml/lwt-3.1:=
	>=dev-ml/ocaml-ssl-0.4.0:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~arm ~ppc"
S="${WORKDIR}/lwt-${P}/"

src_compile() {
	jbuilder build -p ${PN} || die
}

src_test() {
	jbuilder runtest -p ${PN} || die
}
