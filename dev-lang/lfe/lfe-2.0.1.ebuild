# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs

DESCRIPTION="Lisp-flavoured Erlang"
HOMEPAGE="http://lfe.github.io/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/rvirding/${PN}.git"
else
	SRC_URI="https://github.com/rvirding/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="mirror test"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc emacs"

RDEPEND="
	dev-lang/erlang
"
DEPEND="
	${RDEPEND}
	doc? ( virtual/pandoc )
"

SITEFILE="70${PN}-gentoo.el"

src_prepare() {
	default

	sed -i "s|cc |$(tc-getCC) ${CFLAGS} |g" ./Makefile \
		|| die "Failed to fix the makefile"
}

src_compile() {
	emake compile

	use doc && emake docs
	use emacs && emake emacs
}

src_install() {
	dodir "/usr/$(get_libdir)/erlang/lib/lfe/ebin/"
	cp -R ./ebin "${D}/usr/$(get_libdir)/erlang/lib/lfe/"
	dobin ./bin/*

	if use doc; then
		dodoc ./doc/*.txt
		doman ./doc/man/*
	fi

	if use emacs; then
		elisp-install lfe emacs/* \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
