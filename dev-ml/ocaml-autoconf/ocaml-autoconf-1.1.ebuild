# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-autoconf/ocaml-autoconf-1.1.ebuild,v 1.4 2012/03/08 21:44:03 hwoarang Exp $

EAPI="2"

DESCRIPTION="autoconf macros to support configuration of OCaml programs and libraries"
HOMEPAGE="http://ocaml-autoconf.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/282/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install || die
	dodoc README
}
