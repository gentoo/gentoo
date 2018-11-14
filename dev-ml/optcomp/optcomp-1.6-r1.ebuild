# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Optional compilation for OCaml with cpp-like directives"
HOMEPAGE="https://github.com/diml/optcomp"
SRC_URI="https://github.com/diml/optcomp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/camlp4:="
RDEPEND="${DEPEND}"

DOCS=( CHANGES.md README.md )
