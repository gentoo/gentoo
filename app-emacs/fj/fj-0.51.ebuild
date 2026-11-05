# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="GNU Emacs client for interacting with remote Forgejo instances"
HOMEPAGE="https://codeberg.org/martianh/fj.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/martianh/${PN}.el"
else
	SRC_URI="https://codeberg.org/martianh/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.codeberg.tar.gz"
	S="${WORKDIR}/${PN}.el"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-editors/emacs-${NEED_EMACS}[json(+)]
	>=app-emacs/compat-31.0
	>=app-emacs/fedi-0.5
	>=app-emacs/magit-4.3.8
	>=app-emacs/tp-0.9
	>=app-emacs/transient-0.10.0
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="
	Cask
	Makefile
"
DOCS=( readme.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
