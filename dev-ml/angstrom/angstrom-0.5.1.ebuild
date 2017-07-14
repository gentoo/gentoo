# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Parser combinators built for speed and memory efficiency"
HOMEPAGE="https://github.com/inhabitedtype/angstrom"
SRC_URI="https://github.com/inhabitedtype/angstrom/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+lwt async"

RDEPEND="
	dev-ml/ocaml-cstruct:=
	dev-ml/ocplib-endian:=
	dev-ml/result:=
	lwt? ( dev-ml/lwt:= )
	async? ( dev-ml/async:= )
"
DEPEND="${RDEPEND}
	test? ( dev-ml/alcotest )"

# needs old alcotest...
RESTRICT="test"

DOCS=( README.md )

src_configure() {
	oasis_configure_opts="$(use_enable lwt) $(use_enable async)" oasis_src_configure
}
