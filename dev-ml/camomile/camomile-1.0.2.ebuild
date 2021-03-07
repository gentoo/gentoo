# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Camomile is a comprehensive Unicode library for ocaml"
HOMEPAGE="https://github.com/yoriyuki/Camomile/wiki"
SRC_URI="https://github.com/yoriyuki/Camomile/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="+ocamlopt"

# Unbound module errors
RESTRICT="test"

src_compile() {
	# Amend standard dune_src_compile with -p camomile
	# Needed to workaround: https://github.com/yoriyuki/Camomile/issues/83
	# (https://dune.readthedocs.io/en/stable/faq.html#how-to-make-warnings-non-fatal)
	dune build -p camomile @install || die
}
