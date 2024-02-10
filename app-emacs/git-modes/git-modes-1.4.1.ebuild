# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs major modes for editing Git configuration files"
HOMEPAGE="https://github.com/magit/git-modes/"
SRC_URI="https://github.com/magit/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"

RDEPEND=">=app-emacs/compat-29.1.4.1"
BDEPEND="${RDEPEND}"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	elisp-make-autoload-file
}
