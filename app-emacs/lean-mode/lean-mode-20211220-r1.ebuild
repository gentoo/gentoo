# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=a4205749d20a09871f0951c34f919d4ee5fbdb55
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Emacs mode for the Lean 3 theorem prover"
HOMEPAGE="https://github.com/leanprover/lean-mode/"
SRC_URI="https://github.com/leanprover/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${H}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=app-emacs/dash-2.18.1
	>=app-emacs/f-0.19.0
	>=app-emacs/flycheck-32
	>=app-emacs/s-1.10.0
"
RDEPEND="
	${BDEPEND}
	sci-mathematics/lean:0/3
"

DOCS=( README.md )
ELISP_REMOVE="company-lean.el helm-lean.el"
SITEFILE="50${PN}-gentoo.el"
