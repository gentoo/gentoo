# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/dose3/dose3-4.0_rc3.ebuild,v 1.1 2015/07/01 09:34:12 aballier Exp $

EAPI=5

MY_P="${P/_beta/-beta}"
MY_P="${MY_P/_rc/-rc}"
DESCRIPTION="Library and a collection of tools to perform la large spectrum of analysis on package repositories"
HOMEPAGE="http://dose.gforge.inria.fr/public_html/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/34909/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
#Breaks dev-ml/opam, its sole revdep
#KEYWORDS="~amd64"
IUSE="+ocamlopt +parmap zip bzip2 xml curl rpm4 test"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/cudf:=
	dev-ml/extlib:=
	dev-ml/ocaml-re:=
	dev-ml/cppo:=
	parmap? ( dev-ml/parmap:= )
	zip? ( dev-ml/camlzip:= )
	bzip2? ( dev-ml/camlbz2:= )
	>=dev-ml/ocamlgraph-1.8.5:=
	xml? ( dev-ml/ocaml-expat:= dev-ml/xml-light:= )
	curl? ( dev-ml/ocurl:= )
	rpm4? ( app-arch/rpm )
"
DEPEND="${RDEPEND}
	dev-ml/findlib
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
		--with-ocamlgraph \
		$(use xml && echo "--with-xml") \
		$(use curl && echo "--with-curl") \
		$(use rpm4 && echo "--with-rpm4")
}

src_compile() {
	emake -j1
}
