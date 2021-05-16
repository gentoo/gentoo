# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="gettext"
inherit dune

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-ml/cppo-1.6.6
	dev-ml/dune-configurator
"
RDEPEND="
	dev-ml/base:=
	>=dev-ml/camomile-0.8.3:=[ocamlopt=]
	>=dev-ml/ocaml-fileutils-0.4.0:=[ocamlopt=]
	sys-devel/gettext
"
DEPEND="
	${RDEPEND}
	test? ( dev-ml/ounit2[ocamlopt=] )
"

src_prepare() {
	default

	# Port to dev-ml/ounit2
	sed -i -e 's/oUnit/ounit2/' test/{,common,test-camomile,test-stub}/dune || die
}

src_install() {
	dune_src_install
}
