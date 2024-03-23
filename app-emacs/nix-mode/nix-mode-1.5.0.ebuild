# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing Nix expressions"
HOMEPAGE="https://github.com/NixOS/nix-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/NixOS/${PN}.git"
else
	SRC_URI="https://github.com/NixOS/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	app-emacs/company-mode
	app-emacs/magit
	app-emacs/mmm-mode
	app-emacs/transient
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"
