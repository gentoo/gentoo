# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Minimal Xml parser and printer for OCaml"
HOMEPAGE="http://tech.motion-twin.com/xmllight.html"
SRC_URI="http://tech.motion-twin.com/zip/${P}.zip"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="doc +ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/01_installopt.patch
	"${FILESDIR}"/02_cmi_depends.patch
	"${FILESDIR}"/03_cflags.patch
	"${FILESDIR}"/04_dtd_trace.patch
)

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

	cat > "${ED}"/usr/$(get_libdir)/ocaml/${PN}/META || die << EOF
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

		docinto html
		dodoc doc/*
	fi
}
