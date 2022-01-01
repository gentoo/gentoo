# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Generation of bin_prot readers and writers from types"
HOMEPAGE="https://github.com/janestreet/ppx_bin_prot"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE="+ocamlopt test"

DEPEND="
	dev-ml/base:=
	dev-ml/bin_prot:=
	dev-ml/ppx_here:=
	dev-ml/ppxlib:=
		dev-ml/ocaml-migrate-parsetree:=
			dev-ml/result:=
	"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-ml/ppx_jane
	)"
