# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_P="${P/-mode}"
MY_P="${MY_P/_/-}"

DESCRIPTION="GNU Emacs mode for handling CMake build files"
HOMEPAGE="https://cmake.org/"
SRC_URI="https://cmake.org/files/v$(ver_cut 1-2)/${MY_P}.tar.gz"
S="${WORKDIR}/${P/-mode}/Auxiliary"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	!dev-build/cmake[emacs(-)]
"

DOCS=()
SITEFILE="50${PN/-mode}-gentoo.el"

src_install() {
	elisp_src_install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
