# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Error-recovering streaming HTML5 and XML parsers"
HOMEPAGE="https://github.com/aantron/markup.ml"
SRC_URI="https://github.com/aantron/markup.ml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/lwt:=
	dev-ml/uutf:="
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit2 )"

S="${WORKDIR}/${PN}.ml-${PV}"
