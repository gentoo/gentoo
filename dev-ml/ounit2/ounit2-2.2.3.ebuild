# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Unit testing framework for OCaml"
HOMEPAGE="https://github.com/gildor478/ounit"
SRC_URI="https://github.com/gildor478/ounit/releases/download/v${PV}/ounit-v${PV}.tbz"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
DEPEND="
	dev-ml/lwt:=
	dev-ml/stdlib-shims:=
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+ocamlopt"

S="${WORKDIR}/ounit-v${PV}"
