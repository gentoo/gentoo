# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="${P/_beta/-beta}"
DESCRIPTION="Library and a collection of tools to perform la large spectrum of analysis on package repositories"
HOMEPAGE="http://www.mancoosi.org/software/ https://gforge.inria.fr/projects/dose"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/36063/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt parmap zip bzip2 xml curl rpm4 test"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/cudf:=
	>=dev-ml/extlib-1.7.0:=
	dev-ml/ocaml-re:=
	dev-ml/cppo:=
	parmap? ( dev-ml/parmap:= )
	zip? ( dev-ml/camlzip:= )
	bzip2? ( dev-ml/camlbz2:= )
	>=dev-ml/ocamlgraph-1.8.6:=
	xml? ( dev-ml/ocaml-expat:= dev-ml/xml-light:= )
	curl? ( dev-ml/ocurl:= )
	rpm4? ( app-arch/rpm )
"
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/ocamlbuild
	test? ( dev-python/pyyaml[libyaml] )
"
# missing test data
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e 's/INSTALLOPTS=-s/INSTALLOPTS=/' -i Makefile.config.in || die
}

src_configure() {
	econf \
		$(use ocamlopt || echo "--with-bytecodeonly") \
		$(use parmap && echo "--with-parmap") \
		$(use zip && echo "--with-zip") \
		$(use bzip2 && echo "--with-bz2") \
		$(use xml && echo "--with-xml") \
		$(use curl && echo "--with-curl") \
		$(use rpm4 && echo "--with-rpm4")
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" BINDIR="${ED}/usr/bin" install || die
	dodoc CHANGES CREDITS README.architecture TODO
}
