# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/-camomile/}
MY_P=${P/-camomile/}
DUNE_PKG_NAME="gettext-camomile"
inherit dune

DESCRIPTION="Support for internationalization of OCaml programs using the Camomile library"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-ml/cppo-1.6.6
	dev-ml/dune-configurator
"
RDEPEND="
	dev-ml/base:=
	dev-ml/camomile:=[ocamlopt]
	dev-ml/ocaml-gettext:=
"
DEPEND="
	${RDEPEND}
	test? (
		dev-ml/ounit2[ocamlopt=]
		dev-ml/ocaml-fileutils
	)
"

src_prepare() {
	default

	# Port to dev-ml/ounit2
	sed -i -e 's/oUnit/ounit2/' test/{,common,test-camomile,test-stub}/dune || die
}
