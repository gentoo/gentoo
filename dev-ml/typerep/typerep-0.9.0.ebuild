# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Library for creating runtime representation of OCaml types"
HOMEPAGE="https://github.com/janestreet/typerep"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/base:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/jbuilder"
