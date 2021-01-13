# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Unicode text normalization"
HOMEPAGE="https://erratique.ch/software/uunf https://github.com/dbuenzli/uunf"
SRC_URI="https://erratique.ch/software/uunf/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-ml/topkg
	dev-ml/uutf
	dev-ml/cmdliner"
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/findlib"
OPAM_FILE=opam

src_compile() {
	ocaml pkg/pkg.ml build \
		|| die
}
