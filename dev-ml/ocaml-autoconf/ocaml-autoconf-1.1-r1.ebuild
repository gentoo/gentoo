# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="autoconf macros to support configuration of OCaml programs and libraries"
HOMEPAGE="http://ocaml-autoconf.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/282/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install
	dodoc README
}
