# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Unique multiplayer wargame"
HOMEPAGE="https://ufoot.org/liquidwar/"
SRC_URI="https://ufoot.org/download/liquidwar/v5/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND=">=media-libs/allegro-4.2:0[X]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-exec-stack.patch
	"${FILESDIR}"/${P}-gcc10.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:$(GMAKE):$(MAKE):' \
		-e "/^DOCDIR/ s:=.*:= ${EPREFIX}/usr/share/doc/\$(PF):" Makefile.in \
		|| die 'sed Makefile.in failed'
}

src_configure() {
	tc-export CC
	econf \
		--disable-doc-ps \
		--disable-doc-pdf \
		$(use_enable x86 asm)
}

src_compile() {
	# skip build_doc target wrt bug 460344
	emake build_bin build_data
}

src_install() {
	emake DESTDIR="${D}" install_nolink
	einstalldocs
	make_desktop_entry ${PN} "Liquid War" /usr/share/pixmaps/${PN}.xpm
}
