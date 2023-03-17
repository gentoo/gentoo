# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Unit testing framework for OCaml"
HOMEPAGE="https://github.com/gildor478/ounit"
SRC_URI="https://github.com/gildor478/ounit/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ounit-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/lwt:=
	dev-ml/stdlib-shims:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-dune.patch )

src_install() {
	dune-install ${PN} ${PN}-lwt
}
