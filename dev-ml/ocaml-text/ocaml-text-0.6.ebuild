# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="library for dealing with 'text'"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-text/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/937/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="pcre"

DEPEND="virtual/libiconv
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
	pcre? ( dev-ml/pcre-ocaml:=[ocamlopt?] )"
RDEPEND="${DEPEND}"

DOCS=( "README" "CHANGES" "CHANGES.darcs" )

src_configure() {
	oasis_configure_opts="$(use_enable pcre)" \
		oasis_src_configure
}
