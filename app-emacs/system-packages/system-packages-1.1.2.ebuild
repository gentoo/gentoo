# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Manage your installed packages with Emacs"
HOMEPAGE="https://gitlab.com/jabranham/system-packages/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/jabranham/${PN}"
else
	SRC_URI="https://gitlab.com/jabranham/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
ELISP_REMOVE=".dir-locals.el"
SITEFILE="50${PN}-gentoo.el"
