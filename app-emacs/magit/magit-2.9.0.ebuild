# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
NEED_EMACS=24

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/"
SRC_URI="https://github.com/magit/magit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${P}/lisp"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="../Documentation/*.texi"
DOCS="../README.md ../Documentation/AUTHORS.md ../Documentation/RelNotes/${PV}.txt"

DEPEND=">=app-emacs/dash-2.13.0 >=app-emacs/with-editor-2.5.8"
RDEPEND="${DEPEND} >=dev-vcs/git-1.9.4"
DEPEND="${DEPEND} sys-apps/texinfo"

src_prepare() {
	default
	echo "(setq magit-version \"${PV}\")" > magit-version.el || die
}
