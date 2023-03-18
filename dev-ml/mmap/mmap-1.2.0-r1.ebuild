# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="File mapping"
HOMEPAGE="https://github.com/mirage/mmap/"
SRC_URI="https://github.com/mirage/mmap/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/bigarray-compat:="
DEPEND="${RDEPEND}"
