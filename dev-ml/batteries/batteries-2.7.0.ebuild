# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit oasis

DESCRIPTION="The community-maintained foundation library for your OCaml projects"
HOMEPAGE="https://github.com/ocaml-batteries-team/batteries-included/"
SRC_URI="https://github.com/ocaml-batteries-team/batteries-included/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/camomile:="
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit dev-ml/iTeML )"

DOCS=( "ChangeLog" "FAQ" "README.folders" "README.md" )

S="${WORKDIR}/${PN}-included-${PV}"
