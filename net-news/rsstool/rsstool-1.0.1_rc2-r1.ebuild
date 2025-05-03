# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=${PN}-${PV/_}

DESCRIPTION="cmdline tool to read, parse, merge, and write RSS (and Atom) feeds"
HOMEPAGE="https://sourceforge.net/projects/rsstool/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}-src.zip"
S="${WORKDIR}"/${MY_P}-src/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	dev-libs/libxml2:=
	net-misc/curl
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	sed -e '1i#!/bin/bash' -i configure || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" BINDIR="/usr/bin" install

	docinto html
	dodoc ../{changes,faq,readme}.html
}
