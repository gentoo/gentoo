# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"

inherit readme.gentoo-r1 elisp

DESCRIPTION="Completion style that matches multiple regexps in any order"
HOMEPAGE="https://github.com/oantolin/orderless/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/oantolin/${PN}"
else
	SRC_URI="https://github.com/oantolin/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.0.2.0
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

ELISP_TEXTINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

DOC_CONTENTS="Enable orderless completion by placing
	\"(setq completion-styles '(orderless))\" in your .emacs file."

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
