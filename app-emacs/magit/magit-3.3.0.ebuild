# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/"
SRC_URI="https://github.com/magit/magit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${P}/lisp"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="../Documentation/*.texi"
DOCS="../README.md ../Documentation/AUTHORS.md ../Documentation/RelNotes/*"

DEPEND="
	>=app-emacs/dash-2.19.1
	app-emacs/libegit2
	>=app-emacs/transient-0.3.6
	>=app-emacs/with-editor-3.0.5
"
RDEPEND="${DEPEND} >=dev-vcs/git-2.0.0"
DEPEND="${DEPEND} sys-apps/texinfo"

src_prepare() {
	default
	echo "(setq magit-version \"${PV}\")" > magit-version.el || die
}
