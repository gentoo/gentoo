# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: This package contains libraries: biblio-core and biblio

EAPI=8

inherit elisp

DESCRIPTION="Browse and import bibliographic references with Emacs"
HOMEPAGE="https://github.com/cpitclaudel/biblio.el/"
SRC_URI="https://github.com/cpitclaudel/${PN}.el/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
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

ELISP_REMOVE="${PN}-pkg.el"

DOCS=( README.md etc )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup tests

src_prepare() {
	elisp_src_prepare

	sed -i tests/biblio-tests.el \
		-e 's|it "shows bindings|xit "shows bindings|g' || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
