# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp toolchain-funcs

DESCRIPTION="Enchanted Spell Checker for GNU Emacs"
HOMEPAGE="https://github.com/minad/jinx"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/minad/${PN}"
else
	SRC_URI="https://github.com/minad/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-31.0.0.1
	app-text/enchant:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

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
