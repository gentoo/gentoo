# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Display the key bindings following your currently entered keys"
HOMEPAGE="https://github.com/justbur/emacs-which-key/"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

ELISP_REMOVE="which-key-pkg.el"

DOC_CONTENTS="To enable \"which-key-mode\" globally,
	add the following to your init file:
	\n\t(which-key-mode)"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-install "${PN}" ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	readme.gentoo_create_doc
}
