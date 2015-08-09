# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils flag-o-matic multilib toolchain-funcs

MY_P="${P}-MIT"
DESCRIPTION="C/Migemo -- Migemo library implementation in C"
HOMEPAGE="http://www.kaoriya.net/#CMIGEMO"
SRC_URI="http://www.kaoriya.net/dist/var/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc x86"
IUSE="emacs unicode vim-syntax"

DEPEND="dev-lang/perl
	>=app-dicts/migemo-dict-200812[unicode=]
	app-i18n/qkc"
RDEPEND=">=app-dicts/migemo-dict-200812[unicode=]
	emacs? ( >=app-text/migemo-0.40-r1 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2-migemo-dict.diff"
	touch dict/SKK-JISYO.L
	if use unicode ; then
		sed -i -e "/gcc:/s/euc-jp/utf-8/" dict/dict.mak || die
	fi

	# Bug #246953
	sed -i -e "s:-Wl,-rpath[^ ]*::" compile/Make_gcc.mak || die
}

src_compile() {
	append-flags -fPIC
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" gcc || die
}

src_install() {
	# parallel make install borks
	emake -j1 \
		prefix="${D}/usr" \
		libdir="${D}/usr/$(get_libdir)" \
		gcc-install || die

	local encoding
	if use unicode ; then
		encoding="utf-8"
	else
		encoding="euc-jp"
	fi

	mv "${D}/usr/share/migemo/${encoding}/"*.dat "${D}/usr/share/migemo/"
	rm -rf "${D}/usr/share/migemo/"{cp932,euc-jp,utf-8}

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/plugin
		doins tools/migemo.vim
	fi

	dodoc doc/{README_j,TODO_j,vimigemo}.txt
}

pkg_postinst() {
	if use emacs ; then
		elog
		elog "Please add to your ~/.emacs"
		elog "    (setq migemo-command \"cmigemo\")"
		elog "    (setq migemo-options '(\"-q\" \"--emacs\" \"-i\" \"\\\\a\"))"
		elog "    (setq migemo-dictionary \"/usr/share/migemo/migemo-dict\")"
		elog "    (setq migemo-user-dictionary nil)"
		elog "    (setq migemo-regex-dictionary nil)"
		elog "to use cmigemo instead of migemo under emacs."
		elog
	fi
}
