# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Maps of integers implemented as Patricia trees"
HOMEPAGE="https://github.com/backtracking/ptmap"
SRC_URI="https://github.com/backtracking/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/seq:=
	dev-ml/stdlib-shims:=
"
DEPEND="${RDEPEND}"
