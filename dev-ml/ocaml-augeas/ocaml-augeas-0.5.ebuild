# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib

DESCRIPTION="Ocaml bindings for Augeas"
HOMEPAGE="http://augeas.net/"
#SRC_URI="http://augeas.net/download/ocaml/${P}.tar.gz"
SRC_URI="http://people.redhat.com/~rjones/augeas/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-admin/augeas
		dev-ml/ocaml-autoconf
		dev-ml/findlib
		dev-lang/ocaml"
RDEPEND="${DEPEND}"

src_install() {
	findlib_src_install
}
