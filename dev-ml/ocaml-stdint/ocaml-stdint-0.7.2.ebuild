# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="stdint"

inherit dune

DESCRIPTION="Signed and unsigned integer types having specified widths"
HOMEPAGE="https://github.com/andrenth/ocaml-stdint"
SRC_URI="https://github.com/andrenth/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # some tests fails
