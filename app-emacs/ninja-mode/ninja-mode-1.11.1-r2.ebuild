# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs mode for handling Ninja build files"
HOMEPAGE="https://github.com/ninja-build/ninja"
SRC_URI="https://github.com/ninja-build/${PN/-mode}/archive/v${PV}.tar.gz -> ${P/-mode}.tar.gz"
S="${WORKDIR}"/${P/-mode}/misc

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="!<dev-build/ninja-1.11.1-r4[emacs(-)]"

DOCS=()

SITEFILE="50${PN}-gentoo.el"
