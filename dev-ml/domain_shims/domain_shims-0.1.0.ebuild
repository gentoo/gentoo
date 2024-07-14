# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A non-parallel implementation of Domains compatible with OCaml 4"
HOMEPAGE="https://gitlab.com/gasche/domain-shims"
SRC_URI="https://gitlab.com/gasche/domain-shims/-/archive/${PV}/domain-shims-${PV}.tar.gz"
S="${WORKDIR}/domain-shims-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.12:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

RESTRICT="test"
