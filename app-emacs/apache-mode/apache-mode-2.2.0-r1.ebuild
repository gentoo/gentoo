# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing Apache configuration files"
HOMEPAGE="https://github.com/emacs-php/apache-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-php/${PN}"
else
	SRC_URI="https://github.com/emacs-php/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~ppc ~riscv x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
