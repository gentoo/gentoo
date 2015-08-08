# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Library for dealing with 'text'"
HOMEPAGE="https://github.com/vbmithr/ocaml-text/"
SRC_URI="https://github.com/vbmithr/ocaml-text/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="pcre"

RDEPEND="virtual/libiconv
	dev-ml/camlp4:=
	pcre? ( dev-ml/pcre-ocaml:=[ocamlopt?] )"
DEPEND="${RDEPEND}
	doc? ( dev-tex/rubber virtual/latex-base )"

DOCS=( "README" "CHANGES" )

src_configure() {
	oasis_configure_opts="$(use_enable pcre)" \
		oasis_src_configure
}

src_install() {
	oasis_src_install
	use doc && dodoc manual/*.pdf
}
