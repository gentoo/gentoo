# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic toolchain-funcs vcs-snapshot

EGIT_COMMIT="e0f6145f61e0b7058c3006f344e58571d9fdd83a"

DESCRIPTION="Migemo library implementation in C"
HOMEPAGE="https://www.kaoriya.net/software/cmigemo/"
SRC_URI="https://github.com/koron/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86"
IUSE="unicode vim"

RDEPEND=">=app-dicts/migemo-dict-200812[unicode=]"
DEPEND="${RDEPEND}"
BDEPEND="app-i18n/nkf
	dev-lang/perl
	|| (
		net-misc/curl
		net-misc/wget
		www-client/fetch
	)"

PATCHES=(
	# bug #246953
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-ldflags.patch
)
DOCS=( doc/{README_j,TODO_j,vimigemo}.txt )

src_prepare() {
	default

	touch dict/SKK-JISYO.L || die
	if use unicode; then
		sed -i "/gcc:/s/euc-jp/utf-8/" dict/dict.mak || die
	fi

	# bug #255813
	sed -i "/^docdir/s:/doc/migemo:/share/doc/${PF}:" compile/config.mk.in || die
}

src_compile() {
	append-flags -fPIC
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		gcc-all
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		libdir="${ED}/usr/$(get_libdir)" \
		gcc-install
	einstalldocs

	local encoding
	if use unicode; then
		encoding="utf-8"
	else
		encoding="euc-jp"
	fi

	mv "${ED}"/usr/share/migemo/${encoding}/*.dat "${ED}"/usr/share/migemo || die
	rm -rf "${ED}"/usr/share/migemo/{cp932,euc-jp,utf-8}

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins tools/migemo.vim
	fi
}
