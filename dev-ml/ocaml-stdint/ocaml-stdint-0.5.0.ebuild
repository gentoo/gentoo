# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Various signed and unsigned integers for OCaml"
HOMEPAGE="https://github.com/andrenth/ocaml-stdint"
SRC_URI="https://github.com/andrenth/ocaml-stdint/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
