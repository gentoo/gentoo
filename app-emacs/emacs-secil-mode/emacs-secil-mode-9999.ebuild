# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Simple Emacs major mode for editing SELinux CIL format files"
HOMEPAGE="https://salsa.debian.org/dgrift/emacs-secil-mode"

if [[ "${PV}" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://salsa.debian.org/dgrift/${PN}.git"
else
	SRC_URI="https://salsa.debian.org/dgrift/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
