# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
NEED_EMACS=25

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/"
SRC_URI="https://github.com/magit/magit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${P}/lisp"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="../Documentation/*.texi"
DOCS="../README.md ../Documentation/AUTHORS.md ../Documentation/RelNotes/*"

DEPEND="
	>=app-emacs/dash-2.14.1
	>=app-emacs/ghub-3.0.0
	>=app-emacs/magit-popup-2.12.4
	>=app-emacs/with-editor-2.8.0
"
RDEPEND="${DEPEND} >=dev-vcs/git-2.0.0"
DEPEND="${DEPEND} sys-apps/texinfo"

src_prepare() {
	default
	echo "(setq magit-version \"${PV}\")" > magit-version.el || die
}
