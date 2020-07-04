# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="EditorConfig plugin for Geany"
HOMEPAGE="https://github.com/editorconfig/editorconfig-geany/"
EGIT_COMMIT="v${PV}"
SRC_URI="https://github.com/editorconfig/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
CDEPEND="app-text/editorconfig-core-c:="
DEPEND="${CDEPEND}
	dev-util/geany"
RDEPEND="${CDEPEND}"
S=${WORKDIR}/${PN}-${EGIT_COMMIT#v}

src_prepare() {
	eapply_user
	sed -e "s|^\\(EDITORCONFIG_PREFIX =\\).*|\\1 ${EPREFIX}/usr|" \
		-e "s|^\\(CFLAGS =\\).*|\\1 -fPIC $("$(tc-getPKG_CONFIG)" --cflags geany geany) ${CFLAGS}|" \
		-e "s|^\\(LDFLAGS =.*\\)|\\1 ${LDFLAGS}|" \
		-e "s|\`pkg-config[^\`]*\`||" \
		-i Makefile || die
}

src_install() {
	exeinto "$("$(tc-getPKG_CONFIG)" --variable=libdir geany)/geany"
	doexe ${PN}.so
	dodoc README.md
}
