# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=26
COMMIT="ab1a53a6a0120872e42582fc980e779d47de6d0e"

BUILD_DIR="."

inherit cmake elisp

DESCRIPTION="Emacs bindings for libgit2"
HOMEPAGE="https://github.com/magit/libegit2"
SRC_URI="https://github.com/magit/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
# The tests seem to be written specifically for the libegit2 git repository.
RESTRICT="test"

DEPEND=">=dev-libs/libgit2-1.0.0:="
RDEPEND="${DEPEND}
	>=app-editors/emacs-26:*[dynamic-loading]"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

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
