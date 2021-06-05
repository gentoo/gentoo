# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=26
COMMIT="0ef8b13aef011a98b7da756e4f1ce3bb18e4d55a"

BUILD_DIR=.

inherit cmake elisp

DESCRIPTION="Emacs bindings for libgit2"
HOMEPAGE="https://github.com/magit/libegit2"
SRC_URI="https://github.com/magit/libegit2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/libgit2-1.0.0"
RDEPEND="${DEPEND}
	>=app-editors/emacs-26:*[dynamic-loading]"

S="${WORKDIR}/${PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

# The tests seem to be written specifically for the libegit2 git
# repository.
RESTRICT="test"

src_prepare() {
	# Don't build against the bundled submodule
	sed -i -e '/subdirectory.*libgit2/ s/^/#/' CMakeLists.txt || die

	rm -f test.el || die

	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	elisp_src_compile
}

src_install() {
	elisp_src_install
	elisp-modules-install ${PN} libegit2.so
}
