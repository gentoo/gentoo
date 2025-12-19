# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs mode for handling Ninja build files"
HOMEPAGE="https://github.com/ninja-build/ninja/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ninja-build/${PN/-mode}.git"
else
	SRC_URI="https://github.com/ninja-build/${PN/-mode}/archive/v${PV}.tar.gz
		-> ${P/-mode}.tar.gz"
	S="${WORKDIR}/${P/-mode}/misc"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	!<dev-build/ninja-1.11.1-r4[emacs(-)]
"

DOCS=()
SITEFILE="50${PN}-gentoo-r1.el"
