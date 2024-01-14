# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

# Upstream didn't create a git tag for version 1.6.0, this source
# tarball is from the repository at commit 3273fcece5d, the commit that
# bumped the version to 1.6.0.

DESCRIPTION="An improved Go mode for emacs"
HOMEPAGE="https://github.com/dominikh/go-mode.el"
SRC_URI="https://dev.gentoo.org/~matthew/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

ELISP_REMOVE="test/go-fill-paragraph-test.el"

SITEFILE="50${PN}-1.6.0-gentoo.el"
DOCS=( README.md )

elisp-enable-tests ert test

src_prepare() {
	elisp_src_prepare

	# fix path to testdata directory when running tests
	sed -i 's|testdata|test/&|g' \
		test/go-indentation-test.el || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
