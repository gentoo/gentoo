# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="gettext"
inherit dune

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc +ocamlopt"

BDEPEND="dev-ml/cppo"
RDEPEND="
	>=dev-ml/camomile-0.8.3:=
	>=dev-ml/ocaml-fileutils-0.4.0:=
	sys-devel/gettext
"
DEPEND="
	${RDEPEND}
	doc? ( app-text/docbook-xsl-stylesheets dev-libs/libxslt )
"

src_install() {
	dune_src_install

	# Hack for now until we get --mandir in dune.eclass
	cd "${ED}/usr/man" || die
	doman man1/* man5/*
	rm -r "${ED}/usr/man" || die
}
