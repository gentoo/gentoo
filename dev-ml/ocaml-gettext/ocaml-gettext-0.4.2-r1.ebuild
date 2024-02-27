# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="gettext"
inherit dune

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="test"  # Tests fail

BDEPEND="
	>=dev-ml/cppo-1.6.6
	dev-ml/dune-configurator
"

RDEPEND="
	dev-ml/base:=
	>=dev-ml/ocaml-fileutils-0.4.0:=[ocamlopt=]
	sys-devel/gettext
"
DEPEND="
	${RDEPEND}
	test? ( dev-ml/ounit2[ocamlopt=] )
"

src_prepare() {
	default

	# Remove dependency on camomile (see
	# https://github.com/gildor478/ocaml-gettext/issues/14)
	rm -r src/lib/gettext-camomile || die
	rm -r test/test-camomile || die

	# Port to dev-ml/ounit2
	sed -i -e 's/oUnit/ounit2/' test/{,common,test-stub}/dune || die
}
