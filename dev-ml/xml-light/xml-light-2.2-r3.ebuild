# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch multilib

DESCRIPTION="Minimal Xml parser and printer for OCaml"
HOMEPAGE="http://tech.motion-twin.com/xmllight.html"
SRC_URI="http://tech.motion-twin.com/zip/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="doc +ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=dpatch EPATCH_SOURCE="${FILESDIR}" \
	epatch
}

src_compile() {
	emake -j1

	if use ocamlopt; then
		emake -j1 opt
	fi

	if use doc;then
		emake doc
	fi
}

src_test() {
	# There are no tests...
	:
}

src_install() {
	dodir /usr/$(get_libdir)/ocaml/${PN}
	emake INSTALLDIR="${D}"/usr/$(get_libdir)/ocaml/${PN} install
	cat > "${D}"/usr/$(get_libdir)/ocaml/${PN}/META << EOF
name="${PN}"
version="${PV}"
description="${DESCRIPTION}"
requires=""
archive(byte)="xml-light.cma"
EOF
	if use ocamlopt; then
		emake INSTALLDIR="${D}"/usr/$(get_libdir)/ocaml/${PN} installopt
		echo 'archive(native)="xml-light.cmxa"' >> "${ED}"/usr/$(get_libdir)/ocaml/${PN}/META || die
	fi

	dodoc README

	if use doc; then
		emake doc
		dohtml doc/*
	fi
}
