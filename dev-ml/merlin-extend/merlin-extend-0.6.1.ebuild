# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="SDK to extend Merlin"
HOMEPAGE="https://github.com/let-def/merlin-extend/"
SRC_URI="https://github.com/let-def/merlin-extend/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:="
DEPEND="
	${RDEPEND}
	dev-ml/cppo
"
