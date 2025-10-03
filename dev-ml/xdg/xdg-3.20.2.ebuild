# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="XDG Base Directory Specification"
HOMEPAGE="https://github.com/ocaml/dune/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml/dune.git"
else
	SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz
		-> dune-${PV}.tar.gz"
	S="${WORKDIR}/dune-${PV}"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE="+ocamlopt"

# This is a part of dune, running tests would run them for dune, not this lib.
RESTRICT="test"

BDEPEND="
	>=dev-ml/dune-3.20
"

src_configure() {
	:
}

src_compile() {
	dune-compile "${PN}"
}
