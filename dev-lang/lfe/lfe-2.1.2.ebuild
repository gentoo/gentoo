# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs

DESCRIPTION="Lisp-flavoured Erlang, a lisp syntax front-end to the Erlang compiler"
HOMEPAGE="http://lfe.github.io/
	https://github.com/rvirding/lfe/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/rvirding/${PN}.git"
else
	SRC_URI="https://github.com/rvirding/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="emacs"

RDEPEND="
	dev-lang/erlang
	emacs? ( >=app-editors/emacs-23.1:* )
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="70${PN}-gentoo.el"

src_compile() {
	emake HOSTCC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" compile

	use emacs && emake emacs
}

src_install() {
	insinto /usr/$(get_libdir)/erlang/lib/lfe/
	doins -r ebin
	exeinto /usr/bin
	doexe ./bin/*

	dodoc doc/*.txt
	doman doc/man/*

	if use emacs ; then
		elisp-install lfe emacs/*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
