# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="EditorConfig plugin for Geany"
HOMEPAGE="https://github.com/editorconfig/${PN}/"
EGIT_COMMIT="9dce3bb476728a8f4124aefe12e0a4ffc8567dff"
SRC_URI="https://github.com/editorconfig/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
CDEPEND="app-text/editorconfig-core-c:="
DEPEND="${CDEPEND}
	dev-util/geany"
RDEPEND="${CDEPEND}"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_prepare() {
	eapply_user
	sed -e "s|^\\(EDITORCONFIG_PREFIX =\\).*|\\1 ${EPREFIX}/usr|" \
		-e "s|^\\(CFLAGS =\\).*|\\1 -fPIC $("$(tc-getPKG_CONFIG)" --cflags geany geany) ${CFLAGS}|" \
		-e "s|\`pkg-config[^\`]*\`||" \
		-i Makefile || die
}

src_install() {
	exeinto "$("$(tc-getPKG_CONFIG)" --variable=libdir geany)/geany"
	doexe ${PN}.so
	dodoc README.md
}
