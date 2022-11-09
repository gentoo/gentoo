# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Expands [@disable_unused_warnings]"
HOMEPAGE="https://github.com/janestreet/ppx_disable_unused_warnings"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:${SLOT}
	>=dev-ml/ppxlib-0.23.0:="
RDEPEND="${DEPEND}"
