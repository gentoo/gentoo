# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Portable clock implementation for Unix and Xen"
HOMEPAGE="https://github.com/mirage/mirage-clock"
SRC_URI="https://github.com/mirage/mirage-clock/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

BDEPEND="dev-ml/dune-configurator"

src_install() {
	dune-install mirage-clock mirage-clock-solo5 mirage-clock-unix
}
