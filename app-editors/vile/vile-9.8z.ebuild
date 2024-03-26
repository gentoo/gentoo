# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with app-editors/xvile

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="https://invisible-island.net/vile/"
SRC_URI="https://invisible-island.net/archives/vile/current/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/vile/current/${P}.tgz.asc )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="perl iconv"

RDEPEND=">=sys-libs/ncurses-5.2:=
	virtual/libcrypt:=
	iconv? ( virtual/libiconv )
	perl? ( dev-lang/perl:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	virtual/pkgconfig
	verify-sig? ( >=sec-keys/openpgp-keys-thomasdickey-20240114 )
"
IDEPEND="app-eselect/eselect-vi"

src_configure() {
	econf \
		--disable-stripping \
		--with-ncurses \
		--with-pkg-config \
		$(use_with iconv) \
		$(use_with perl)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc CHANGES* README doc/*.doc
	docinto html
	dodoc doc/*.html
}

pkg_postinst() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}
