# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1
inherit edo elisp toolchain-funcs

DESCRIPTION="Enchanted Spell Checker for GNU Emacs"
HOMEPAGE="https://github.com/minad/jinx"

SRC_URI="
	https://github.com/minad/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/enchant:2
	>=app-emacs/compat-29.1.4.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

SITEFILE="50${PN}-gentoo.el"

ELISP_TEXINFO="${PN}.texi"

src_compile() {
	edo $(tc-getCC) -fPIC -Wall -Wextra -shared \
		$($(tc-getPKG_CONFIG) --cflags --libs enchant-2) \
		${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -o jinx-mod.so jinx-mod.c
	elisp-org-export-to texinfo README.org
	elisp_src_compile
}

src_install() {
	elisp-make-autoload-file
	elisp_src_install

	elisp-modules-install "${PN}" jinx-mod.so
	doinfo jinx.info
}
