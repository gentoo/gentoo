# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Tool and library implementing patience diff"
HOMEPAGE="https://github.com/janestreet/patience_diff"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~riscv"
IUSE="+ocamlopt"

RDEPEND="dev-ml/core:${SLOT}"
