# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: This package contains libraries: biblio-core and biblio

EAPI=8

COMMIT=517ec18f00f91b61481214b178f7ae0b8fbc499b
NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Browse and import bibliographic references with Emacs"
HOMEPAGE="https://github.com/cpitclaudel/biblio.el/"
SRC_URI="https://github.com/cpitclaudel/${PN}.el/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/dash"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/buttercup
		app-emacs/noflet
		app-emacs/undercover
	)
"

DOCS=( README.md etc )
PATCHES=( "${FILESDIR}"/${PN}-0.2-tests.patch )

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	buttercup -L . -L tests --traceback full tests || die
}
