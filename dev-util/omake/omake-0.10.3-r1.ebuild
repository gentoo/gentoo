# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Make replacement"
HOMEPAGE="http://projects.camlcity.org/projects/omake.html"
SRC_URI="http://download.camlcity.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc fam ncurses +ocamlopt readline"
RESTRICT="installsources !ocamlopt? ( strip )"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	ncurses? ( >=sys-libs/ncurses-5.3:0= )
	fam? ( virtual/fam )
	readline? ( >=sys-libs/readline-4.3:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.2-cflags.patch"
)

src_configure() {
	./configure \
		-prefix "${EPREFIX}/usr" \
		$(use readline || echo '-disable-readline') \
		$(use ncurses  || echo '-disable-ncurses' ) \
		$(use fam      || echo '-disable-fam'     ) \
		|| die
}

src_compile() {
	emake all
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc ChangeLog CONTRIBUTORS.org README.md
	if use doc; then
		dodoc doc/ps/omake-doc.pdf doc/txt/omake-doc.txt
		dodoc -r doc/html
	fi
}
