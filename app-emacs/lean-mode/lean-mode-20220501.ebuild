# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 20220501 ]] && COMMIT=362bc6fa3efb1874c525ed6b4b6f24f76af22596

inherit elisp

DESCRIPTION="Emacs mode for the Lean 3 theorem prover"
HOMEPAGE="https://github.com/leanprover/lean-mode/"
SRC_URI="https://github.com/leanprover/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

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
