# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Multi-engine SMT-based automatic model checker"
HOMEPAGE="https://kind2-mc.github.io/kind2/
	https://github.com/kind2-mc/kind2/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kind2-mc/${PN}.git"
else
	SRC_URI="https://github.com/kind2-mc/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/menhir:=
	dev-ml/num:=
	dev-ml/yojson:=
	dev-ml/zmq:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/dune-build-info
	test? ( dev-ml/ounit2 )
"
