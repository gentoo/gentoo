# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NEED_EMACS="24.1"

inherit elisp

DESCRIPTION="Provide information about Emacs packages"
HOMEPAGE="https://github.com/emacsorphanage/pkg-info"
SRC_URI="https://github.com/emacsorphanage/pkg-info/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x64-macos"
RESTRICT="test"  # Tests fail

RDEPEND=">=app-emacs/epl-0.8"

SITEFILE="50${PN}-gentoo.el"
DOCS=( README.md CHANGES.md )
