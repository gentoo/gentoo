# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Colored patience diffs with word-level refinement"
HOMEPAGE="https://github.com/janestreet/patdiff"
SRC_URI="https://github.com/janestreet/patdiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/core_unix:${SLOT}
	dev-ml/patience_diff:${SLOT}
	dev-ml/pcre-ocaml:=
"
DEPEND="${RDEPEND}"
