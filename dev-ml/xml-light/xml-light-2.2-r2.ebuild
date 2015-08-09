# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Minimal Xml parser and printer for OCaml"
HOMEPAGE="http://tech.motion-twin.com/xmllight.html"
SRC_URI="http://tech.motion-twin.com/zip/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-lang/ocaml:="
DEPEND="app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=dpatch EPATCH_SOURCE="${FILESDIR}" \
	epatch
}

src_compile() {
	emake -j1
	if use doc;then
		emake doc
	fi
}

src_install() {
	dodir /usr/$(get_libdir)/ocaml/${PN}
	emake INSTALLDIR="${D}"/usr/$(get_libdir)/ocaml/${PN} install
	cat > "${D}"/usr/$(get_libdir)/ocaml/${PN}/META << EOF
name="${PN}"
version="${PV}"
description="${DESCRIPTION}"
requires=""
archive(byte) = "xml-light.cma"
EOF
	dodoc README
	if use doc; then
		emake doc
		dohtml doc/*
	fi
}
