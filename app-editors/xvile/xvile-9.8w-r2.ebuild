# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with app-editors/vile

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

MY_P="${PN/x/}-${PV}"
DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="https://invisible-island.net/vile/"
SRC_URI="https://invisible-island.net/archives/vile/current/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/vile/current/${MY_P}.tgz.asc )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~riscv sparc x86"
IUSE="perl"

RDEPEND="
	~app-editors/vile-${PV}
	virtual/libcrypt:=
	>=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libICE-1.0.0
	>=x11-libs/libSM-1.0.0
	>=x11-libs/libXaw-1.0.1
	>=x11-libs/libXpm-3.5.4.2
	perl? ( dev-lang/perl:= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-alternatives/lex
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

PATCHES=( "${FILESDIR}/${P}"-fix-build-for-clang16.patch )

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		--disable-stripping \
		--with-ncurses \
		--with-pkg-config \
		--with-x \
		$(use_with perl)
}

src_install() {
	dobin xvile
	dodoc CHANGES* README doc/*.doc
	docinto html
	dodoc doc/*.html
}
