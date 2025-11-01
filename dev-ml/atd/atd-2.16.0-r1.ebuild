# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Static types for JSON APIs"
HOMEPAGE="https://github.com/ahrefs/atd/"
SRC_URI="https://github.com/ahrefs/atd/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	dev-ml/biniou:=
	dev-ml/cmdliner:=
	dev-ml/easy-format:=
	dev-ml/menhir:=
	dev-ml/re:=
	dev-ml/yojson:=
"
DEPEND="
	${RDEPEND}
"

DUNE_PACKAGES=(
	atd
	atdgen
	atdgen-codec-runtime
	atdgen-runtime
	atdj
	atdpy
	atds
	atdts
)

src_compile() {
	dune-compile "${DUNE_PACKAGES[@]}"
}

src_test() {
	nonfatal dune_src_test
}

src_install() {
	dune-install "${DUNE_PACKAGES[@]}"
	einstalldocs
}
