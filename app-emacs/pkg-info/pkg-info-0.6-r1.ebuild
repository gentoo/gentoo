# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Provide information about Emacs packages"
HOMEPAGE="https://github.com/emacsorphanage/pkg-info/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacsorphanage/${PN}"
else
	SRC_URI="https://github.com/emacsorphanage/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test"  # Tests fail

RDEPEND="
	>=app-emacs/epl-0.8
"

DOCS=( README.md CHANGES.md )
SITEFILE="50${PN}-gentoo.el"
