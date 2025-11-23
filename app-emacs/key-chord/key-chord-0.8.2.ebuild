# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Map pairs of simultaneously pressed keys to commands"
HOMEPAGE="https://github.com/emacsorphanage/key-chord/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacsorphanage/${PN}"
else
	SRC_URI="https://github.com/emacsorphanage/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
