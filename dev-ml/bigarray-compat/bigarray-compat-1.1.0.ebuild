# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Compatibility library to use Stdlib.Bigarray when possible"
HOMEPAGE="https://github.com/mirage/bigarray-compat"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
