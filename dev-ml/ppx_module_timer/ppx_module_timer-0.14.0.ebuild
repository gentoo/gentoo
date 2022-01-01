# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Ppx rewriter that records top-level module startup times"
HOMEPAGE="https://github.com/janestreet/ppx_module_timer"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_base:=
	dev-ml/stdio:=
	dev-ml/time_now:=
	dev-ml/ppxlib:=
		dev-ml/result:=
"
RDEPEND="${DEPEND}"
