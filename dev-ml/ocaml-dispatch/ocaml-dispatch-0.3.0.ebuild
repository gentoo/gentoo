# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Path-based dispatching for client- and server-side applications"
HOMEPAGE="https://github.com/inhabitedtype/ocaml-dispatch"
SRC_URI="https://github.com/inhabitedtype/ocaml-dispatch/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="javascript"

DEPEND="
	javascript? ( dev-ml/js_of_ocaml:=[ppx,ocamlopt?] )
	dev-ml/result:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/ounit[ocamlopt?] )
"

DOCS=( "README.md" )

src_configure() {
	oasis_configure_opts="$(use_enable javascript js-of-ocaml)" \
		oasis_src_configure
}
