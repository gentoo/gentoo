# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Behaviour-driven Elisp testing"
HOMEPAGE="https://github.com/jorgenschaefer/emacs-buttercup"
SRC_URI="https://github.com/jorgenschaefer/emacs-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc ~ppc64 ~riscv sparc x86"

DOCS=( docs/{running,writing}-tests.md  )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l buttercup \
			 -f buttercup-run-discover || die "tests failed"
}

src_install() {
	elisp_src_install
	dobin bin/${PN}
}
